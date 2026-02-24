import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository_impl.dart'; // 如果你有 repository 层
import 'package:flutter_demo2/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeView extends BaseViews<HomeController> {
  HomeView({super.key})
    : super(
        bgImage: PageBackground(
          imagePath: Assets.images.backgronud.path, // 建议修正拼写 → background
          top: 0.0,
          left: 0.0,
          width: 375.w,
          height: 812.h + MediaQuery.of(Get.context!).padding.top,
          fit: BoxFit.fitHeight,
        ),
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      );

  @override
  Widget? appBar(BuildContext context) => null;
  
  @override
  Widget body(BuildContext context) {
    // TODO: implement body
    throw UnimplementedError();
  }
  
}