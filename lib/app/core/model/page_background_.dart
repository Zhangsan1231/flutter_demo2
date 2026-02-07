import 'package:flutter/cupertino.dart';

/// 页面背景配置类
/// 
/// 用于配置页面背景图片的各种属性，包括位置、大小、适配方式等
/// 主要用于统一管理应用中不同页面的背景样式
class PageBackground {
  /// 背景图片路径
  /// 
  /// 支持本地资源路径和网络图片URL
  final String imagePath;

  /// 背景图片位置
  /// 
  /// 控制背景图片在容器中的对齐方式
  /// 默认为居中对齐
  final Alignment alignment;

  /// 背景图片宽度
  /// 
  /// 设置背景图片的显示宽度
  /// 默认为100
  final double width;

  /// 背景图片高度
  /// 
  /// 设置背景图片的显示高度
  /// 默认为100
  final double height;

  /// 背景图片适配方式
  /// 
  /// 控制背景图片如何填充容器
  /// 默认为BoxFit.cover，表示填充整个容器
  final BoxFit fit;

  /// 背景图片顶部偏移量
  /// 
  /// 控制背景图片距离顶部的距离
  /// 默认为0
  final double top;

  /// 背景图片左侧偏移量
  /// 
  /// 控制背景图片距离左侧的距离
  /// 默认为0
  final double left;

  /// 创建一个页面背景配置
  /// 
  /// [imagePath] 背景图片路径
  /// [alignment] 背景图片位置，默认为居中对齐
  /// [width] 背景图片宽度，默认为100
  /// [height] 背景图片高度，默认为100
  /// [top] 顶部偏移量，默认为0
  /// [left] 左侧偏移量，默认为0
  /// [fit] 背景图片适配方式，默认为BoxFit.cover
  const PageBackground({
    required this.imagePath,
    this.alignment = Alignment.center,
    this.width = 100,
    this.height = 100,
    this.top = 0,
    this.left = 0,
    this.fit = BoxFit.cover,
  });
}