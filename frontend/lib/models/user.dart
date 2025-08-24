// lib/models/user.dart

import '../helpers/parse_jwt.dart'; // 導入解析 JWT 的輔助函式

class User {
  final String id;
  final String username;
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiry;
  final DateTime refreshTokenExpiry;

  User({
    required this.id,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiry,
    required this.refreshTokenExpiry,
  });

  factory User.fromJwt(String accessToken, String refreshToken) {
    try {
      final accessPayload = parseJwt(accessToken);
      final refreshPayload = parseJwt(refreshToken); // 解析 refresh token 的 payload

      // 1. 確認從 Payload 中獲取正確的鍵名
      // JWT 標準中，用戶 ID 通常是 'sub'
      final String id = accessPayload['sub'] as String;
      final String username = accessPayload['username'] as String; // 假設 username 在 access token payload 中

      // 2. 提取過期時間 (Unix timestamp，單位是秒) 並轉換為 DateTime
      final int accessExpSeconds = accessPayload['exp'] as int;
      final int refreshExpSeconds = refreshPayload['exp'] as int;

      final DateTime accessTokenExpiry = DateTime.fromMillisecondsSinceEpoch(accessExpSeconds * 1000);
      final DateTime refreshTokenExpiry = DateTime.fromMillisecondsSinceEpoch(refreshExpSeconds * 1000);

      return User(
        id: id,
        username: username,
        accessToken: accessToken,
        refreshToken: refreshToken,
        accessTokenExpiry: accessTokenExpiry,
        refreshTokenExpiry: refreshTokenExpiry,
      );
    } catch (e) {
      throw FormatException('Failed to parse JWT tokens to User object: $e');
    }
  }

  // 判斷 Access Token 是否過期
  bool get isAccessTokenExpired => DateTime.now().isAfter(accessTokenExpiry);

  // 判斷 Refresh Token 是否過期
  bool get isRefreshTokenExpired => DateTime.now().isAfter(refreshTokenExpiry);

  @override
  String toString() {
    return 'User(id: $id, username: $username, accessTokenExpiry: $accessTokenExpiry, refreshTokenExpiry: $refreshTokenExpiry)';
  }
}