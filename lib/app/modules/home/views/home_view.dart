import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository_impl.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends BaseViews<HomeController> {
  HomeView({super.key})
    : super(
        bgImage: PageBackground(
          imagePath: Assets.images.backgronud.path, // 注意拼寫改成 background
          top: 0.0,
          left: 0.0,
          width: 375.w,
          // width: Get.width,           // 螢幕寬度
          // height: Get.height+MediaQuery.of(Get.context!).padding.top,         // 螢幕高度
          height: 812.w + MediaQuery.of(Get.context!).padding.top,
          fit: BoxFit.fitHeight, // 建議用 cover 全屏鋪滿
        ),
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // 看圖片顏色決定
      );

  @override
  Widget? appBar(BuildContext context) {
    return null;
  }

@override
Widget body(BuildContext context) {
  return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // 测试通道是否通畅（可选，先验证通道）
                // final channelTest = await AizoRingService.testChannel();
                // print('通道测试结果: $channelTest');

                // 正式初始化 SDK
                final success = await BluetoothRepositoryImpl().init();
                if (success) {
                  Get.snackbar('成功', 'AIZO RING SDK 初始化成功！');
                } else {
                  Get.snackbar('失败', 'SDK 初始化失败，请查看日志');
                }
              },
              child: Text('测试初始化 SDK'),
            ),
          ],
        ),
  );
}
}