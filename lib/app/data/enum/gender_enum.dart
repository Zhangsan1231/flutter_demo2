import 'package:flutter/material.dart';

/// 性别枚举
/// 用于统一管理性别选项，避免字符串硬编码
enum Gender {
  /// 男
  male('男'),

  /// 女
  female('女'),

  /// 保密/其他
  confidential('保密');

  /// 显示的中文文本
  final String label;

  const Gender(this.label);

  /// 根据中文 label 反向查找枚举值
  static Gender? fromLabel(String label) {
    try {
      return values.firstWhere((e) => e.label == label);
    } catch (_) {
      return null;
    }
  }

  /// 获取图标（可选，用于 UI 显示）
  IconData get icon {
    switch (this) {
      case Gender.male:
        return Icons.male;
      case Gender.female:
        return Icons.female;
      case Gender.confidential:
        return Icons.privacy_tip;
    }
  }

  /// 获取图标颜色（可选）
  Color get color {
    switch (this) {
      case Gender.male:
        return Colors.blue;
      case Gender.female:
        return Colors.pink;
      case Gender.confidential:
        return Colors.grey;
    }
  }
}