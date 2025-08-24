import 'package:flutter/cupertino.dart';
import 'package:frontend/widgets/login/login_form.dart';
import 'package:provider/provider.dart';

import '../services/login_service.dart';
import '../viewmodels/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // 通常頁面級別的 Scaffold 應該有導航欄
      navigationBar: const CupertinoNavigationBar(middle: Text("登入")),
      child: SafeArea(
        // 確保內容不會被劉海或狀態欄遮擋
        child: Center(
          child: SingleChildScrollView(
            // 包裹 SingleChildScrollView 防止鍵盤遮擋
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // 整個表單的邊距
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
