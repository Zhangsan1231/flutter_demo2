import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/my_bluetooth_controller.dart';

class MyBluetoothView extends BaseViews<MyBluetoothController> {
  MyBluetoothView({super.key}) : super(bgColor: Color(0xfffafafa));
  @override
  Widget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              // image: DecorationImage(image: AssetImage(Assets.images.bluetoothBg.path,),fit: BoxFit.cover),
            ),
            child: Stack(
              clipBehavior: Clip.none, // ★关键：允许子组件溢出不裁剪
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: Image.asset(
                    Assets.images.bluetoothBg.path,
                    width: 467.w,
                    height: 467.h,
                  ),
                  top: -170.h, // ★ 控制露出多少：负值越大，露出的部分越少（越接近半圆）
                  left: -46.h,
                ),

                // 图片居中
                Image.asset(
                  Assets.images.userBluetooth.path,
                  width: 142.w,
                  height: 142.h,
                ),

                // top: 101.h,
                // left: 172.h,

                // Icon 定位在左上角
                Positioned(
                  left: 10.w,
                  top: 10.h,
                  child: Icon(Icons.arrow_back_ios),
                ),
              ],
            ),
          ),
          Gap(70.h),
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Colors.white
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('My device'),
                  ),

                  // Container(child: screenWidth,)
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () {
              Get.toNamed(Routes.BLUETOOTH_DEVICES);
            },
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 60.w),
              padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.h),
                border: Border.all(color: Color(0xff1e6dff)),
              ),
              child: Text('Add Device'),
            ),
          ),
          Gap(70.h),
        ],
      ),
    );
  }
}
