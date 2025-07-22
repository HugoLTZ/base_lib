import 'package:flutter/material.dart';

/// TestPageVars UI样式变量
class TestPageVarsVars {
  // 颜色变量
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF333333);
  static const Color secondaryTextColor = Color(0xFF666666);
  static const Color dividerColor = Color(0xFFE0E0E0);
  
  // 字体样式
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: secondaryTextColor,
  );
  
  // 尺寸变量
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double iconSize = 24.0;
  
  // 间距变量
  static const EdgeInsets defaultMargin = EdgeInsets.all(16.0);
  static const EdgeInsets smallMargin = EdgeInsets.all(8.0);
  static const EdgeInsets largeMargin = EdgeInsets.all(24.0);
  
  // 动画时长
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  
  // 阴影样式
  static const BoxShadow defaultShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8.0,
    offset: Offset(0, 2),
  );
}