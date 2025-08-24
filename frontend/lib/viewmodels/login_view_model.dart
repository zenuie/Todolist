import 'package:flutter/cupertino.dart';
import '../models/user.dart';
import '../services/login_service.dart';

class LoginViewModel extends ChangeNotifier {
  User? _user;
  String? _error;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  // 暴露出去
  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  // 你需要傳入 loginService，或在這裡建立
  final LoginService _loginService;

  LoginViewModel(this._loginService);

  Future<void> init() async {
    // 我們在這裡不直接執行 checkAutoLogin
    // 因為 init() 是同步的，而 checkAutoLogin 是異步的
    // checkAutoLogin 會由 AuthWrapper 的 initState 調用
    // 這裡可以做一些 ViewModel 自身的初始化準備
    print('LoginViewModel initialized.');
  }

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

  Future<void> checkAutoLogin() async {
    _isLoading = true;
    _error = null; // 清除之前的錯誤
    notifyListeners();

    try {
      final tokens = await _loginService.loadTokens();
      final accessToken = tokens['access_token'];
      final refreshToken = tokens['refresh_token'];

      if (accessToken != null) {
        _user = User.fromJwt(accessToken, refreshToken ?? ''); // 從 Token 建立用戶實例

        if (_user!.isAccessTokenExpired) {
          print('Access Token 已過期');
          if (_user!.isRefreshTokenExpired) {
            print('Refresh Token 也已過期，需要重新登入');
            _user = null;
            _isLoggedIn = false;
            await _loginService.clearTokens();
            _error = '登入已過期，請重新登入。';
          } else {
            print('Access Token 過期，嘗試刷新');
            final newTokenJson = await _loginService.refreshAccessToken(_user!.refreshToken);
            _user = User.fromJwt(newTokenJson['access_token'], newTokenJson['refresh_token'] ?? '');
            _isLoggedIn = true;
          }
        } else {
          _isLoggedIn = true; // Access Token 尚未過期，直接登入
        }
      } else {
        print('沒有本地儲存的 Access Token');
        _isLoggedIn = false;
      }
    } catch (e) {
      print('自動登入或Token刷新失敗: $e');
      _error = '自動登入失敗，請重新登入。';
      _user = null;
      _isLoggedIn = false;
      await _loginService.clearTokens(); // 清除可能損壞的 Token
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
