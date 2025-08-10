import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/services/login_service.dart';

Future<Map<String, dynamic>> getTestToken() async {
  await dotenv.load(fileName: '.env');
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  final username = dotenv.env['USERNAME'] ?? '';
  final password = dotenv.env['PASSWORD'] ?? '';

  final loginService = LoginService('$baseUrl/account/login');
  return await loginService.login(username, password);
}
