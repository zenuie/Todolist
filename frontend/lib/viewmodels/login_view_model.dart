import 'package:flutter/cupertino.dart';
import '../models/user.dart';
import '../services/login_service.dart';

class LoginViewModel extends ChangeNotifier {
  User? _user;
  String? _error;
  bool _isLoading = false;

  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // 你需要傳入 loginService，或在這裡建立
  final LoginService _loginService;

  LoginViewModel(this._loginService);

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 假設 loginService.login 回傳 Map<String, dynamic>，內容有 access_token、refresh_token
      final tokenJson = await _loginService.login(username, password);
      final accessToken = tokenJson['access_token'];
      final refreshToken = tokenJson['refresh_token'];

      _user = User.fromJwt(accessToken, refreshToken);
    } catch (e) {
      _error = e.toString();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
