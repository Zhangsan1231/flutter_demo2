import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/bluetooth_devices_controller.dart';

class BluetoothDevicesView extends BaseViews<BluetoothDevicesController> {
  BluetoothDevicesView({super.key})
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
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.w),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 整体左对齐，减少重复写 Align
        children: [
          Align(alignment: .topLeft, child: Icon(Icons.arrow_back_ios)),
          Gap(30.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select and add devices',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Synchronize device data to provide you with more accurate health interpretation services',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff666666),
              ),
            ),
          ),
          Gap(50.h),
          Text(
              'Data synchronization',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff333333),
              ),
            ),

          Gap(10.h),
          //Data synchronization
          Container(

            padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
            decoration: BoxDecoration(color: Color(0x0d1B6BFF),
            borderRadius: BorderRadius.circular(8.h)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  Assets.images.health.path,
                  width: 48.w,
                  height: 46.h,
                ),
                Gap(10.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Health',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff333333),
                        ),
                      ),
                      Container(
                        // width: double.infinity,
                        child: Text(
                          'Support users to synchronize their health data from Apple account to this software',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff999999),
                          ),

                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(10.h),
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
                    'Sync',
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
        
         Gap(10.h),

         //aiRing
         Text(
              'aiRing',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff333333),
              ),
            ),
            Gap(10.h),
          Container(

            padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
            decoration: BoxDecoration(color: Color(0x0d1B6BFF),
            borderRadius: BorderRadius.circular(8.h)),
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
        
         Gap(10.h),

//Weight scale
         Text(
              'Weight scale',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff333333),
              ),
            ),
            Gap(10.h),
          Container(

            padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
            decoration: BoxDecoration(color: Color(0x0d1B6BFF),
            borderRadius: BorderRadius.circular(8.h)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  Assets.images.weightScale.path,
                  width: 48.w,
                  height: 46.h,
                ),
                Gap(10.h),
                Text(
              'aiWeight scale',
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
        
        ],
      ),
    );
  }
}
