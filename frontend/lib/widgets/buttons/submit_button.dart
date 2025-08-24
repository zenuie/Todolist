import 'package:flutter/cupertino.dart';
import 'filled_button.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.color, // 允許覆蓋預設顏色
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final CupertinoDynamicColor? color; // 可以覆寫 FilledButton 的預設顏色

  @override
  Widget build(BuildContext context) {
    return FilledButton( // SubmitButton 預設就是一個實心按鈕
      onPressed: onPressed,
      text: text,
      isLoading: isLoading,
      color: color, // 傳遞顏色，如果為 null 則 AppFilledButton 會用它的預設
    );
  }
}