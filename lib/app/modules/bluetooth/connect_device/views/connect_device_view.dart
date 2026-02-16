import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
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
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
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
          Gap(150.h),

          Text(
            'Move the device close to your phone',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
              color: Color(0xff666666),
            ),
          ),
          Gap(5.h),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff666666), width: 0.5.w),
            ),
          ),
          Gap(15.h),
          Row(
            children: [
              Text(
                'Connect to device succesfully',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff333333),
                ),
              ),

              Spacer(),
              Icon(CupertinoIcons.checkmark_alt_circle),
            ],
          ),
          Gap(20.h),
          InkWell(
            onTap: () {
              Get.bottomSheet(
                isScrollControlled: true,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.h),
                  ),
                  // margin: EdgeInsets.symmetric(horizontal: 10.w),
                  width: double.infinity,

                  // height: 700.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // ← 关键！让 Column 只占内容所需高度
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
                        '2. On the device page, click “Forget this device”.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff666666),
                        ),
                      ),
                      Gap(16.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 80.w,vertical: 8.h),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.h),
                          gradient: LinearGradient(colors: [
                            Color(0xff57EBFF),
                            Color(0xff1c6bff)
                          ]),),
                        child: Text(
                        'Go Setting',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffffffff),
                        ),
                      ),),
                    
                     Gap(16.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 80.w,vertical: 8.h),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.h),
                          border: Border.all(
                            color: Color(0xff1B6BFF),
                          )
                          // color: Color(0x0d1B6BFF),
                          // gradient: LinearGradient(colors: [
                          //   Color(0xff57EBFF),
                          //   Color(0xff1c6bff)
                          // ]),
                          ),
                        child: Text(
                        '   Cancel   ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1B6BFF),
                        ),
                      ),),
                      Gap(50.h)
                    
                    
                    ],
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  'Connect to device succesfully',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff333333),
                  ),
                ),

                Spacer(),
                Icon(CupertinoIcons.checkmark_alt_circle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
