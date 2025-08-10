import 'dart:convert';

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Invalid JWT');
  }

  final payload = parts[1];
  // 修正 base64 padding
  String normalized = base64Url.normalize(payload);
  final payloadMap = json.decode(utf8.decode(base64Url.decode(normalized)));

  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('Invalid payload');
  }
  return payloadMap;
}
