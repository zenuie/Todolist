import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/login_view_model.dart';
import '../buttons/submit_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // 1. 輸入框控制器
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. 處理登入提交的函式
  void _submitForm() {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    loginViewModel.login(_usernameController.text, _passwordController.text);
  }

  @override
  void dispose() {
    // 3. 釋放控制器，防止內存洩漏
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 4. 使用 Consumer 或 Provider.of 監聽 ViewModel 的狀態
    // Consumer 會在 ViewModel 變化時重建其 builder 部分
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 5. 帳號輸入框
            CupertinoTextField(
              controller: _usernameController,
              placeholder: "請輸入帳號",
              clearButtonMode: OverlayVisibilityMode.editing,
              keyboardType: TextInputType.emailAddress,
              // 輸入類型
              autocorrect: false,
              // 自動拼字校正 關閉
              textCapitalization: TextCapitalization.none, // 首字母大寫關閉
            ),

            // 6. 間距
            SizedBox(height: 6.0),

            // 7. 密碼輸入框
            CupertinoTextField(
              controller: _passwordController,
              placeholder: "請輸入密碼",
              clearButtonMode: OverlayVisibilityMode.editing,
              obscureText: true,
              enableSuggestions: false,
              // 輸入類型
              keyboardType: TextInputType.visiblePassword,
              // 自動拼字校正 關閉
              autocorrect: false,
              textCapitalization: TextCapitalization.none, // 首字母大寫關閉
            ),

            // 8. 間距
            SizedBox(height: 16.0),

            // 9. 顯示錯誤訊息 (來自 ViewModel)
            if (loginViewModel.error?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  loginViewModel.error.toString(),
                  style: CupertinoTheme.of(context).textTheme.textStyle
                      .copyWith(color: CupertinoColors.systemRed),
                  textAlign: TextAlign.center,
                ),
              ),
            // 10. 登入按鈕
            SubmitButton(
              onPressed: _submitForm,
              text: '登入',
              isLoading: loginViewModel.isLoading,
            ),
            // 11. 註冊或忘記密碼連結 (使用普通 CupertinoButton)
            CupertinoButton(
              child: const Text("註冊帳號"),
              onPressed: () {
                print('前往註冊');
              },
            ),
          ],
        );
      },
    );
  }
}
