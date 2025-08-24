// lib/services/login_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginService {
  final String loginUrl;
  final String _accessToken = 'accessToken';
  final String _refreshToken = 'refreshToken';

  // 建立儲存區
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  LoginService(this.loginUrl);

  // 登入
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String;
      await _saveTokens(accessToken, refreshToken); // 呼叫內部方法儲存 Token
      return data;
    } else {
      throw Exception('登入失敗');
    }
  }

  // 儲存金鑰
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: _accessToken, value: accessToken);
    await _secureStorage.write(key: _refreshToken, value: refreshToken);
    if (kDebugMode) {
      print("金鑰已存入");
    }
  }

  // 讀取金鑰
  Future<Map<String, String?>> loadTokens() async {
    final accessToken = await _secureStorage.read(key: _accessToken);
    final refreshToken = await _secureStorage.read(key: _refreshToken);
    return {'access_token': accessToken, 'refresh_token': refreshToken};
  }

  // 清除金鑰
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessToken);
    await _secureStorage.delete(key: _refreshToken);
    if (kDebugMode) {
      print('金鑰已清除');
    }
  }

  // 使用refresh token 更新access token
  Future<Map<String, dynamic>> refreshAccessToken(String refreshToken) async {
    // 假設你的刷新 API
    final response = await http.post(
      Uri.parse('/refresh-token'), // 替換為你的刷新端點
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refresh_token': refreshToken}),
    );

    // 更新access token and refresh token
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String;
      await _saveTokens(accessToken, refreshToken); // 呼叫內部方法儲存 Token
      return data;
    } else {
      throw Exception('更新金鑰失敗');
    }
  }
}
