// lib/widgets/buttons/filled_button.dart

import 'package:flutter/cupertino.dart';
import '../../config/colors.dart';
import '_button_renderer.dart';

class FilledButton extends StatelessWidget {
  const FilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color = AppColors.primaryBlue,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String text;

  final CupertinoDynamicColor? color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // 所有從 AppColors 獲取的顏色都需要 resolveFrom(context)
    final resolvedBackgroundColor = (color ?? AppColors.primaryBlue)
        .resolveFrom(context);
    final resolvedTextColor = AppColors.buttonTextColor.resolveFrom(context);

    // 傳給 ButtonRenderer 的顏色應該是已經解析好的 Color
    return ButtonRenderer(
      onPressed: isLoading ? null : onPressed,
      // 在這裡處理 isLoading 禁用邏輯
      isFilled: true,
      backgroundColor: resolvedBackgroundColor,
      // 傳遞解析後的顏色
      foregroundColor: resolvedTextColor,
      // 傳遞解析後的文字顏色
      child:
          isLoading
              ? CupertinoActivityIndicator(
                color: resolvedTextColor,
              ) // 載入指示器顏色也需要解析
              : Text(text),
    );
  }
}
