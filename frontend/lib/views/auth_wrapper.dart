import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:frontend/viewmodels/login_view_model.dart';
import 'package:frontend/views/login_view.dart';
import 'package:frontend/views/home_view.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // 為了避免在 build 期間觸發導航，我們會在 initState 或 WidgetsBinding.instance.addPostFrameCallback 中處理
  // 這裡使用 initState，因為我們需要 ViewModel 來執行 checkAutoLogin
  @override
  void initState() {
    super.initState();
    // 延遲執行，確保 build 方法已經完成，並且 Provider 已經可用
    // 在 WidgetsBinding.instance.addPostFrameCallback 中呼叫 ViewModel 的方法是更安全的做法
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<LoginViewModel>(context, listen: false);
      viewModel.checkAutoLogin(); // 應用程式啟動時檢查自動登入
    });
  }

  @override
  Widget build(BuildContext context) {
    // 監聽 LoginViewModel 的狀態
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        // 如果正在載入中，顯示載入畫面
        if (viewModel.isLoading) {
          return const CupertinoPageScaffold(
            child: Center(
              child: CupertinoActivityIndicator(), // iOS 風格的載入指示器
            ),
          );
        } else {
          // 載入完成，根據登入狀態導航
          if (viewModel.isLoggedIn) {
            // 如果已登入，導航到主頁面
            // 使用 Navigator.pushReplacement 替換當前路由，防止回退到此包裝器
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (context) => const HomeView()),
              );
            });
            return const SizedBox.shrink(); // 導航時隱藏此 Widget
          } else {
            // 如果未登入，導航到登入頁面
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (context) => const LoginView()),
              );
            });
            return const SizedBox.shrink(); // 導航時隱藏此 Widget
          }
        }
      },
    );
  }
}