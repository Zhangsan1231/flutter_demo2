import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/core/values/app_colors.dart';
import 'package:flutter_demo2/app/modules/login/widget/login_banner.dart';
import 'package:flutter_demo2/app/modules/login/widget/user_agreement.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends BaseViews<SplashController> {
  SplashView({super.key})
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
    RxBool _checkValue = false.obs;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      // child: IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LoginBanner(),
          Gap(212.h),
          Container(
            height: 47,
            padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 8.h),

            decoration: BoxDecoration(
              color: Color(0xff87E588),
              borderRadius: BorderRadius.circular(36),
            ),
            child: // backgroundColor:AppColors.primaryGreen,
            IntrinsicWidth(
              child: InkWell(
                onTap: () {
                  Get.toNamed('/login');
                  print("微信点击");
                },
                child: Row(
                  children: [
                    Image.asset(Assets.images.wechat.path, height: 31.37.w),
                    SizedBox(width: 4.68.w),
                    Text(
                      "WeChat Login",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            // height: 47.h,
            padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 8.h),

            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: Color(0xff3161FF)),
            ),
            child: // backgroundColor:AppColors.primaryGreen,
            IntrinsicWidth(
              child: InkWell(
                onTap: () {
                  print("谷歌点击");
                },
                child: Row(
                  children: [
                    Image.asset(Assets.images.googe.path, height: 31.37.w),
                    // SizedBox(width: 4.68.w),
                    Gap(4.68.w),
                    Text(
                      "Google Login",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xff3161FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap(20.63.h),
          Container(
            alignment: Alignment.centerRight,

            child: InkWell(
              onTap: () {
                print("other点击");
              },
              child: Text(
                'Other Login >',
                style: TextStyle(color: Color(0xff1E4BDF), fontSize: 12.sp),
              ),
            ),
          ),
          // Gap(153.h),
          //
          // Gap(240.h),
          UserAgreement(),

          // Gap(500.h)
        ],
      ),

      // ),
    );
  }

}
