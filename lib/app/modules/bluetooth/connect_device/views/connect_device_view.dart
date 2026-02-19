import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controllers/connect_device_controller.dart';

class ConnectDeviceView extends BaseViews<ConnectDeviceController> {
  ConnectDeviceView({super.key}) : super(bgColor: Color(0xfffafafa));

  @override
  Widget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      // 绑定成功：展示 All done! + Get Started
      if (controller.bindSuccess.value) {
        return _buildAllDone(context);
      }
      // 绑定中：两步状态（连接成功 ✓、绑定中/绑定成功 ✓）
      return _buildBindingSteps(context);
    });
  }

  /// All done! 最终页
  Widget _buildAllDone(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          Gap(100.h),
          Text(
            'All done!',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff333333),
            ),
          ),
          Gap(40.h),
          Image.asset(Assets.images.aiRing.path, width: 120.w, height: 120.h),
          Gap(40.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'In order to make the measurement result more accurate. Please wear the ring and make it\'s sensors located on palm side of finger.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff666666),
              ),
            ),
          ),
          Gap(60.h),
          InkWell(
            onTap: () {
              Get.offNamed(Routes.BLUETOOTH_SETTING);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 14.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: LinearGradient(
                  colors: [Color(0xff57EBFF), Color(0xff1c6bff)],
                ),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 绑定过程：两步状态 + 提示 + Bluetooth Tips 入口
  Widget _buildBindingSteps(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          Gap(120.h),
          Image.asset(Assets.images.aiRing.path, width: 150.w, height: 150.h),
          Gap(30.h),
          Text(
            'aiRing',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff333333),
            ),
          ),
          Gap(80.h),
          // 第一步：Connect to device success...
          Obx(() => _statusRow(
                'Connect to device succes...',
                done: controller.connectSuccess.value,
                loading: false,
              )),
          Gap(20.h),
          // 第二步：Bind device successfully
          Obx(() => _statusRow(
                'Bind device succesfully',
                done: controller.bindSuccess.value,
                loading: controller.isBinding.value,
              )),
          Gap(30.h),
          Text(
            'Move the device close to your phone',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
              color: Color(0xff666666),
            ),
          ),
          Gap(24.h),
          // Bluetooth Tips 入口
          InkWell(
            onTap: _showBluetoothTips,
            child: Row(
              children: [
                Text(
                  'Connection issues? Tap for Bluetooth Tips',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff1B6BFF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(String label, {required bool done, required bool loading}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xff333333),
          ),
        ),
        Spacer(),
        if (loading)
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1B6BFF)),
            ),
          )
        else if (done)
          Icon(
            CupertinoIcons.checkmark_alt_circle_fill,
            color: Color(0xff34C759),
            size: 24.w,
          ),
      ],
    );
  }

  void _showBluetoothTips() {
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(16.h),
            Text(
              'Bluetooth Tips',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff333333),
              ),
            ),
            Gap(16.h),
            Text(
              'The device has been deleted, in order to ensure that the device is connected normally next time, please ignore.',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff666666),
              ),
            ),
            Gap(16.h),
            Image.asset(
              Assets.images.bluetoothTips1.path,
              width: 241.w,
              height: 198.h,
            ),
            Gap(10.h),
            Text(
              '1. Open \'Settings\' > Bluetooth and find the device.',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff666666),
              ),
            ),
            Gap(16.h),
            Image.asset(
              Assets.images.bluetoothTips2.path,
              width: 241.w,
              height: 119.h,
            ),
            Gap(10.h),
            Text(
              '2. On the device page, click "Forget this device".',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff666666),
              ),
            ),
            Gap(16.h),
            InkWell(
              onTap: () {
                Get.back();
                // 可在此打开系统设置
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: LinearGradient(
                    colors: [Color(0xff57EBFF), Color(0xff1c6bff)],
                  ),
                ),
                child: Text(
                  'Go Setting',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Gap(12.h),
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Color(0xff1B6BFF)),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1B6BFF),
                  ),
                ),
              ),
            ),
            Gap(24.h),
          ],
        ),
      ),
    );
  }
}
