
import 'package:flutter/widgets.dart';
import 'package:flutter_demo2/app/core/values/app_colors.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';

/// 自定义容器组件
/// 
/// 一个带有阴影和圆角的容器组件
/// 用于创建具有立体感的UI元素，如卡片、面板等
/// 支持自定义背景色、内边距、外边距、圆角大小和阴影效果
class ElevatedContainer extends StatelessWidget {
  /// 容器内显示的子组件
  final Widget child;

  /// 容器的背景颜色
  /// 默认为 [AppColors.pageBackground]
  final Color bgColor;

  /// 容器的内边距
  /// 默认为null，表示无内边距
  final EdgeInsetsGeometry? padding;

  /// 容器的外边距
  /// 默认为null，表示无外边距
  final EdgeInsetsGeometry? margin;

  /// 容器的圆角大小
  /// 默认为 [AppValues.smallRadius]
  final double borderRadius;

  /// 容器的阴影效果
  /// 默认为一个轻微的向下阴影效果
  /// 传入null使用默认阴影
  /// 传入空列表[]表示无阴影
  /// 传入自定义阴影列表使用自定义阴影
  final List<BoxShadow>? boxShadow;

  /// 获取默认阴影效果
  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: AppColors.elevatedContainerColorOpacity,
      spreadRadius: 3,
      blurRadius: 8,
      offset: const Offset(0, 3), // 阴影偏移量
    ),
  ];

  /// 构造函数
  /// 
  /// [child] 必填参数，容器内显示的子组件
  /// [bgColor] 可选参数，背景颜色，默认为 [AppColors.pageBackground]
  /// [padding] 可选参数，内边距
  /// [margin] 可选参数，外边距
  /// [borderRadius] 可选参数，圆角大小，默认为 [AppValues.smallRadius]
  /// [boxShadow] 可选参数，阴影效果：
  ///   - 不传或传入null：使用默认阴影
  ///   - 传入空列表[]：无阴影
  ///   - 传入自定义阴影列表：使用自定义阴影
  const ElevatedContainer({
    Key? key,
    required this.child,
    this.bgColor = AppColors.pageBackground,
    this.padding,
    this.margin,
    this.borderRadius = AppValues.smallRadius,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ?? defaultShadow,
        color: bgColor,
      ),
      child: child,
    );
  }
}
