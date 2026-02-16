import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/translations/translation_keys.dart';
import 'package:flutter_demo2/app/modules/login/widget/login_banner.dart';
import 'package:flutter_demo2/app/modules/login/widget/user_agreement.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:logger/logger.dart';

class SplashWidget extends StatefulWidget {
  SplashWidget({Key? key}) : super(key: key);

  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  RxBool splashAgreement = false.obs;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      // child: IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LoginBanner(),
          Gap(150.h),
          Expanded(
              child: Column(
                
                children: [
                  SplashWxLogin(),
                  Gap(20.h),
                  SPlashGoogleLogin(),
                  Gap(20.63.h),
                  SplashOtherLogin(),

                  Spacer(),

                  UserAgreement()

                  // Obx(() => UserAgreement(agreementValue: splashAgreement,),),
                ],
              ),
            
          ),

          // Gap(500.h)
        ],
      ),

      // ),
    );
  }

  Widget SplashWxLogin() {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.LOGIN);
        // logger.d("nihao");
        // Get.toNamed(Routes.HOME);
        
        // print("微信点击 跳转首页");
      },
      child: Container(
        height: 47,
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 8.h),

        decoration: BoxDecoration(
          color: Color(0xff87E588),
          borderRadius: BorderRadius.circular(36),
        ),
        child: // backgroundColor:AppColors.primaryGreen,
        IntrinsicWidth(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              children: [
                Image.asset(Assets.images.wechat.path, height: 31.37.w),
                SizedBox(width: 4.68.w),
                Text(
                  TL.weChatlogin.tr,

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
    );
  }

  Widget SPlashGoogleLogin() {
    return Container(
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
            Get.toNamed(Routes.INFORMATION);
            print("谷歌点击 跳转用户页面");
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              children: [
                Image.asset(Assets.images.googe.path, height: 31.37.w),
                // SizedBox(width: 4.68.w),
                Gap(4.68.w),
                Text(
                  TL.googleLogin.tr,
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
    );
  }

  Widget SplashOtherLogin() {
    return Container(
      margin: EdgeInsets.only(right: 44 - 25.w),
      alignment: Alignment.centerRight,

      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.REGISTER);
          print("other点击");
        },
        child: Text(
          'Other Login >',
          style: TextStyle(color: Color(0xff1E4BDF), fontSize: 12.sp),
        ),
      ),
    );
  }
}
