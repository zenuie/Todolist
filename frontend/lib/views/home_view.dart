// lib/views/home_view.dart
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:frontend/viewmodels/login_view_model.dart'; // 導入 ViewModel
import 'package:frontend/views/login_view.dart'; // 導入登入頁面

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // 監聽 ViewModel，以便在登出時知道
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        // 如果用戶已經登出，導航回登入頁面
        if (!viewModel.isLoggedIn && !viewModel.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => const LoginView()),
            );
          });
          return const SizedBox.shrink();
        }

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text("主頁面"),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                viewModel.logout(); // 點擊登出
              },
              child: const Text("登出"),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("歡迎，${viewModel.user?.username ?? '訪客'}！"),
                const SizedBox(height: 20),
                const Text("你已成功登入。"),
              ],
            ),
          ),
        );
      },
    );
  }
}