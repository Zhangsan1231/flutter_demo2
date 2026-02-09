import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/modules/user/controllers/user_controller.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';


class UserView extends BaseViews<UserController> {
  UserView({super.key})
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
  
  @override
  Widget? appBar(BuildContext context) {
    // TODO: implement appBar
    throw UnimplementedError();
  }
  
  @override
  Widget body(BuildContext context) {
    // TODO: implement body
    throw UnimplementedError();
  }
}
