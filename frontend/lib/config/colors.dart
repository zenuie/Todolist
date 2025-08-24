// lib/config/app_colors.dart
import 'package:flutter/cupertino.dart'; // 導入 Cupertino 以使用 CupertinoDynamicColor

/// 應用程式的顏色定義。
/// 建議使用語義化命名，並考慮淺色/深色模式。
class AppColors {
  // --- 品牌色 (Brand Colors) ---
  // 主要品牌藍色，在淺色和深色模式下可能有不同呈現
  static const CupertinoDynamicColor primaryBlue = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF007AFF), // 淺色模式下的藍色
    darkColor: Color(0xFF0A84FF), // 深色模式下的藍色 (通常會更亮一些，或符合 iOS 深色模式規範)
  );

  // 次要強調色，例如綠色
  static const CupertinoDynamicColor accentGreen = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF34C759),
    darkColor: Color(0xFF30D158),
  );

  // --- 功能色 (Functional Colors) ---
  // 錯誤/警告色 (通常是紅色)
  static const CupertinoDynamicColor warningRed = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFF3B30),
    darkColor: Color(0xFFFF453A),
  );

  // 成功色 (通常是綠色，如果與 accentGreen 不同)
  // static const CupertinoDynamicColor successGreen = CupertinoDynamicColor.withBrightness(
  //   color: Color(0xFF34C759),
  //   darkColor: Color(0xFF30D158),
  // );

  // --- 文本色 (Text Colors) ---
  // 主要文本顏色
  static const CupertinoDynamicColor primaryText = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF000000), // 淺色模式下為黑色
    darkColor: Color(0xFFFFFFFF), // 深色模式下為白色
  );

  // 次要文本顏色 (例如描述性文字)
  static const CupertinoDynamicColor secondaryText = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF8E8E93),
    darkColor: Color(0xFF9E9E9E),
  );

  // 禁用狀態的文本顏色
  static const CupertinoDynamicColor disabledText = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFC7C7CC),
    darkColor: Color(0xFF6C6C70),
  );

  // --- 背景色 (Background Colors) ---
  // 主要頁面背景色
  static const CupertinoDynamicColor primaryBackground = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF), // 淺色模式下為白色
    darkColor: Color(0xFF000000), // 深色模式下為黑色
  );

  // 次要背景色 (例如卡片、組件背景)
  static const CupertinoDynamicColor secondaryBackground = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF2F2F7), // 淺色模式下的淺灰色
    darkColor: Color(0xFF1C1C1E), // 深色模式下的深灰色
  );

  // 浮動組件背景色 (例如彈窗、Sheet)
  static const CupertinoDynamicColor tertiaryBackground = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFE5E5EA),
    darkColor: Color(0xFF2C2C2E),
  );

  // --- 按鈕相關顏色 ---
  // 實心按鈕的預設文字顏色
  static const CupertinoDynamicColor buttonTextColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF), // 實心按鈕上的文字通常是白色
    darkColor: Color(0xFFFFFFFF),
  );

  // 按鈕禁用時的背景色
  static const CupertinoDynamicColor buttonDisabledBackground = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFC7C7CC),
    darkColor: Color(0xFF6C6C70),
  );

  // 邊框按鈕的預設背景色 (通常透明或白色)
  static const CupertinoDynamicColor buttonOutlinedBackground = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF), // 淺色模式下為白色背景
    darkColor: Color(0xFF1C1C1E), // 深色模式下為深色背景
  );
}