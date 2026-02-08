import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/core/utils/logger.dart';
import 'package:flutter_demo2/app/core/values/app_colors.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';
import 'package:flutter_demo2/app/core/widget/elevated_container.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';

abstract class BaseViews<Controller extends BaseController>
    extends GetView<Controller> {
  final Logger logger = LoggerSingleton.getInstance();

  /// 背景颜色
  final Color bgColor;

  /// 页面背景配置
  final PageBackground? bgImage;

  /// 状态栏背景颜色
  final Color statusBarColor;

  /// 状态栏图标颜色（亮色/暗色）
  final Brightness statusBarIconBrightness;

  /// 状态栏样式
  final SystemUiOverlayStyle? statusBarStyle;

  BaseViews({
    super.key,
    this.bgColor = Colors.white,
    this.bgImage,
    this.statusBarColor = Colors.transparent,
    this.statusBarIconBrightness = Brightness.dark,
    this.statusBarStyle,
  });
  Widget body(BuildContext context);
  Widget? appBar(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setSystemUIOverlayStyle(
      statusBarStyle ??
          SystemUiOverlayStyle(
            statusBarColor: statusBarColor,
            statusBarIconBrightness: statusBarIconBrightness,
            statusBarBrightness: statusBarIconBrightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
          ),
    );
    return Material(
      color: bgColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 在 BaseViews 的 build 方法裡，修改 Positioned 部分
if (bgImage != null)
  Positioned(
    top: bgImage!.top - MediaQuery.of(context).padding.top,
    left: bgImage!.left,
    child: SizedBox(  // 改用 SizedBox 更明確
      width: bgImage!.width ?? Get.width,
      height: bgImage!.height ?? Get.height,
      child: Image.asset(
        bgImage!.imagePath,
        fit: bgImage!.fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, color: Colors.red, size: 50);
        },
      ),
    ),
  ),

          SafeArea(
            bottom: false, // 让 body 铺满到底，避免底部露出背景图；需避开安全区时在页面内用 padding
            child: Column(
              children: [
                appBar(context) ?? const SizedBox(),
                Expanded(child: body(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// 显示加载提示
  Widget _showLoading(String message) {
    return Center(
      child: ElevatedContainer(
        padding: EdgeInsets.all(AppValues.margin),
        borderRadius: AppValues.smallRadius,
        bgColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppColors.colorPrimary,
            ),
            if (message.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: AppValues.margin),
                child: Text(
                  message,
                  style: TextStyle(
                    color: AppColors.colorPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  /// 加载遮罩层
  Widget shadowBox() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withAlpha(77),
    );
  }
}
