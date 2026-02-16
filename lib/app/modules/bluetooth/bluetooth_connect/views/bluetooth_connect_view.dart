import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/bluetooth_connect_controller.dart';

class BluetoothConnectView extends BaseViews<BluetoothConnectController> {
  BluetoothConnectView({super.key})
    : super(
        bgColor: Color(0xfffafafa),
        bgImage: PageBackground(
          imagePath: Assets.images.blueBaground.path,
          width: 327.w,
          height: 220.h,
          left: 48.w,
        ),
      );
  @override
  Widget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: Icon(Icons.arrow_back_ios),
      title: Text(
        'Bluetooth',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          color: Color(0xff333333),
        ),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.h),
      child: Column(
        children: [
          Container(
            // margin: EdgeInsets.symmetric(horizontal: 10.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.h),
              color: Color(0xffffffff),
            ),
            child: Row(
              children: [
                // 示例1：旋转圆圈（类似系统，但更柔和）
                SpinKitCircle(
                  color: Colors.blue,
                  size: 24.0,
                  duration: const Duration(milliseconds: 3000),
                ),
                Gap(10.w),
                Text(
                  'Searching for devices...',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff999999),
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.h),
                    border: Border.all(color: Color(0xff1e6dff)),
                  ),
                  child: Text(
                    'Stop',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff1e6dff),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Gap(10.h),
          InkWell(
            onTap: () {
              // Get.toNamed(Routes.BLUETOOTH_CONNECT);
              Get.toNamed(Routes.CONNECT_DEVICE);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Color(0x0d1B6BFF),
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    Assets.images.aiRing.path,
                    width: 48.w,
                    height: 46.h,
                  ),
                  Gap(10.h),
                  Text(
                    'aiRing',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff333333),
                    ),
                  ),
                  Gap(10.h),
                  Spacer(),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff1B6BFF)),
                      borderRadius: BorderRadius.circular(4.h),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),

                    child: Text(
                      'Bind',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff999999),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
