import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 自定义通用 AppBar 组件
///
/// 这是一个封装了 Material Design AppBar 的通用组件，提供了更多自定义选项
/// 主要用于统一应用的导航栏样式和行为
///
/// 使用示例：
/// ```dart
/// CustomAppBar(
///   title: Text('页面标题'),
///   centerTitle: true,
///   backgroundColor: Colors.white,
///   actions: [
///     IconButton(
///       icon: Icon(Icons.search),
///       onPressed: () {},
///     ),
///   ],
/// )
/// ```
class CustomAppBar extends StatelessWidget {
  /// 导航栏标题组件
  ///
  /// 可以是文本、图标或其他任何Widget
  final Widget? title;

  /// 控制标题是否居中显示
  ///
  /// 默认为 true，表示标题居中
  final bool centerTitle;

  /// 导航栏背景颜色
  ///
  /// 默认为主题色，可以自定义
  final Color? backgroundColor;

  /// 导航栏右侧的操作按钮列表
  ///
  /// 通常包含搜索、更多等操作按钮
  final List<Widget>? actions;

  /// 导航栏左侧的按钮
  ///
  /// 默认为返回按钮，可以自定义
  final Widget? leading;

  /// 创建一个自定义的 AppBar
  ///
  /// [title] 导航栏标题
  /// [centerTitle] 是否居中显示标题
  /// [backgroundColor] 背景颜色
  /// [elevation] 阴影高度
  /// [actions] 右侧操作按钮列表
  /// [leading] 左侧按钮
  /// [statusBarColor] 状态栏颜色
  /// [statusBarIconBrightness] 状态栏图标亮度
  /// [statusBarBrightness] iOS 状态栏亮度
  const CustomAppBar({
    Key? key,
    this.title,
    this.centerTitle = true,
    this.backgroundColor,
    this.actions,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      color: backgroundColor ??
          Theme.of(context).appBarTheme.backgroundColor ??
          Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading ?? SizedBox(width: 0),
          Expanded(
            child: Center(
              child: title ?? SizedBox.shrink(),
            ),
          ),
          if (actions != null) ...actions! else SizedBox(width: 0),
        ],
      ),
    );
  }
}
