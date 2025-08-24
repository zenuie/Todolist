// lib/main.dart

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:frontend/viewmodels/login_view_model.dart';
import 'package:frontend/services/login_service.dart';
import 'package:frontend/views/auth_wrapper.dart';

Future<void> main() async {
  // 確保 Flutter 服務已初始化，尤其是在使用插件時（如 flutter_secure_storage）
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 在應用程式的頂層提供 LoginViewModel，以便 AuthWrapper 和其他頁面可以訪問
    return ChangeNotifierProvider(
      create: (context) {
        final loginService = LoginService("https://divine-complete-unicorn.ngrok-free.app/account/login"); // 創建 LoginService 實例
        final viewModel = LoginViewModel(loginService); // 創建 ViewModel 實例
        viewModel.checkAutoLogin(); // !!! 在這裡觸發自動登入檢查 !!!
        return viewModel;
      },
      child: const CupertinoApp(
        title: 'Flutter Demo',
        // !!! 這裡，將 home 指向 AuthWrapper !!!
        home: AuthWrapper(),
      ),
    );
  }
}