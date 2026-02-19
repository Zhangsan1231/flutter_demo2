import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';


class ToastUtil {
  /// 默认动画时长
  static const Duration _defaultAnimationDuration = Duration(milliseconds: 300);
  
  /// 默认显示时长
  static const Duration _defaultDisplayDuration = Duration(seconds: 1);

  /// 创建基础Toast配置
  static CherryToast _createBaseToast({
    required String message,
    required Color themeColor,
    IconData? icon,
  }) {
    return CherryToast(
      title: Text(message),
      themeColor: themeColor,
      icon: icon ?? Icons.info_outline,
      animationType: AnimationType.fromTop,
      animationDuration: _defaultAnimationDuration,
      autoDismiss: true,
      enableIconAnimation: true,
    );
  }

  /// 显示普通消息
  static void showInfo(BuildContext context, String message) {
    _createBaseToast(
      message: message,
      themeColor: Colors.blue,
      icon: Icons.info_outline,
    ).show(context);
  }

  /// 显示成功消息
  static void showSuccess(BuildContext context, String message) {
    _createBaseToast(
      message: message,
      themeColor: Colors.green,
      icon: Icons.check_circle_outline,
    ).show(context);
  }

  /// 显示错误消息
  static void showError(BuildContext context, String message) {
    _createBaseToast(
      message: message,
      themeColor: Colors.red,
      icon: Icons.error_outline,
    ).show(context);
  }

  /// 显示警告消息
  static void showWarning(BuildContext context, String message) {
    _createBaseToast(
      message: message,
      themeColor: Colors.orange,
      icon: Icons.warning_amber_outlined,
    ).show(context);
  }
} 
