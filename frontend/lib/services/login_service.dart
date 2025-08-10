// lib/services/login_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String loginUrl;

  LoginService(this.loginUrl);

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      throw Exception('登入失敗');
    }
  }
}
