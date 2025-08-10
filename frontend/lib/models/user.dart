import '../helpers/parse_jwt.dart';

class User {
  final String id;
  final String username;
  final String accessToken;
  final String refreshToken;

  User({
    required this.id,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  });

  factory User.fromJwt(String accessToken, String refreshToken) {
    final payload = parseJwt(accessToken);
    return User(
      id: payload['user_id'] as String,
      username: payload['username'] as String,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
