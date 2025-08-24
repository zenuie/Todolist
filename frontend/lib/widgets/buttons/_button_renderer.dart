// lib/widgets/buttons/_button_renderer.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // 導入 Material，因為 Container 在 Material Design 包中

// 這個是一個純粹的渲染器，對外部隱藏
class ButtonRenderer extends StatelessWidget {
  const ButtonRenderer({
    required this.onPressed,
    required this.child,
    this.backgroundColor, // 背景色
    this.foregroundColor, // 通常是文本或圖標顏色
    this.borderColor, // 邊框顏色 (針對非實心按鈕)
    this.isFilled = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  final VoidCallback? onPressed; // 可以為 null，表示禁用
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor; // 如果需要邊框
  final bool isFilled;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    // 預設的按鈕子 Widget，確保文字顏色正確
    final Widget themedChild = DefaultTextStyle(
      style: CupertinoTheme.of(
        context,
      ).textTheme.textStyle.copyWith(color: foregroundColor),
      child: child,
    );

    // 無論是實心還是非實心，我們都統一用 Container 包裹來處理背景色和邊框
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor, // Container 的背景色
        border:
            borderColor != null
                ? Border.all(color: borderColor!, width: 1.0)
                : null,
        borderRadius: borderRadius,
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        padding: padding,
        borderRadius: borderRadius,
        // CupertinoButton 的 color 屬性是為按下時的視覺反饋和文本顏色，
        // 而不是設定背景色。如果不需要特殊按下顏色，這裡可以不傳。
        // foregroundColor 已經由 DefaultTextStyle 處理文本顏色，
        // 所以這裡將其留空，或根據需求傳入 CupertinoDynamicColor.resolve(foregroundColor, context)
        // color: (foregroundColor != null && !isFilled) ? foregroundColor : null, // 根據需求決定是否傳入
        child: themedChild,
      ),
    );
  }
}
