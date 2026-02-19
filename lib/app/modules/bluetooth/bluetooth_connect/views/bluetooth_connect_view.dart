import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart';
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
          InkWell(
            onTap: () => controller.startScan(),
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.h),
                color: Color(0xffffffff),
              ),
              child: Row(
                children: [
                  // 示例1：旋转圆圈（类似系统，但更柔和）
                  // SpinKitCircle(
                  //   color: Colors.blue,
                  //   size: 24.0,
                  //   duration: const Duration(milliseconds: 3000),
                  // ),
                  Obx(() {
                    if (controller.searchBluetooth.value == true) {
                      return SpinKitCircle(
                        color: Colors.blue,
                        size: 24.0,
                        duration: const Duration(milliseconds: 3000),
                      );
                    } else {
                      return Gap(24);
                    }
                  }),
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
          ),
          Gap(10.h),
          Expanded(
            child: Obx(() {
              final devices =
                  BluetoothUtil.scanResults; // ← 使用 controller 的 RxList

              if (devices.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bluetooth_disabled_rounded,
                        size: 80.w,
                        color: Colors.grey[400],
                      ),
                      Gap(16.h),
                      Text(
                        '暂未发现设备',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      Gap(8.h),
                      Text(
                        '点击上方按钮开始搜索',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final result = devices[index];
                  final device = result.device;
                  logger.d(' device.advName device.advName :${device.advName}');
                  return InkWell(
                    onTap: () => controller.connect(device),
                    child: Card(
                    margin: EdgeInsets.symmetric(
                      vertical: 6.h,
                      horizontal: 0,
                    ), // 卡片间距
                    elevation: 2, // 轻微阴影（可调 1~4）
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r), // 圆角
                    ),
                    color: Colors.white, // 白色背景
                    child: ListTile(
                      title: Text(
                        device.advName,
                        style: TextStyle(color: Colors.yellow),
                      ),
                      subtitle: Text(device.remoteId.str),
                      trailing: Text(
                        '${result.rssi} dBm',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  )
                
                  );
                
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
