
import 'dart:ui';

import 'package:flutter/material.dart';

/// 应用颜色常量类
/// 
/// 定义应用中使用的所有颜色常量
/// 使用静态常量管理颜色值，便于统一管理和维护
/// 支持主题色、背景色等不同用途的颜色定义
abstract class AppColors {
  /// 主题色
  /// 
  /// 应用的主要品牌色
  /// 用于重要按钮、强调文本等场景
  /// 颜色值：深青色 (#38686A)
  static const Color colorPrimary = Color(0xFF38686A);

  /// 页面背景色
  /// 
  /// 应用的默认页面背景色
  /// 用于页面容器、卡片背景等场景
  /// 颜色值：浅灰色 (#FAFAFA)
  static const Color pageBackground = Color(0xFFFFFF);

  /// 带透明度的容器背景色
  /// 
  /// 用于需要半透明效果的容器背景
  /// 透明度为128（50%）
  /// 基于灰色（Colors.grey）创建
  static Color elevatedContainerColorOpacity = Colors.grey.withAlpha(128);

  /// 常用颜色 000 999 666 333
  static const Color color000 = Color(0xFF000000);
  static const Color color999 = Color(0xFF999999);
  static const Color color666 = Color(0xFF666666);
  static const Color color333 = Color(0xFF333333);

  /// 提示色
  static const Color hintColor = Color(0xFFC8C9CC);

  static const Color primaryGreen = Color(0xFF57C051);
}