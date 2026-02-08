import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/core/values/app_colors.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';
import 'package:flutter_demo2/app/core/widget/custom_appbar.dart';
import 'package:flutter_demo2/app/modules/login/widget/login_banner.dart';
import 'package:flutter_demo2/app/modules/login/widget/user_agreement.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends BaseViews<LoginController> {
  LoginView({super.key})
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
    return Container(
      width: double.infinity,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          // Flex(direction: direction)
          // Spacer(),
          LoginBanner(),
          Gap(30.h),
         
          Expanded(
            child: Container(
              
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.h),
                  topRight: Radius.circular(24.h),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 32.h),
                 child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      
                      children: [
                        Text('Account Number' ,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18.sp),),
                        Gap(16.h),
                        TextField(
                          
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.h)),
                            
                            hintText: 'Please enter your account number',
                            hintStyle: TextStyle(fontSize: 12.sp)
                          ),
                        ),
                        Gap(21.h),
                         Text('Password' ,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18.sp),),
                        Gap(16.h),
                        TextField(
                          
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.h)),
                            
                            hintText: 'Please enter your password',
                            hintStyle: TextStyle(fontSize: 12.sp),
                            suffixIcon: Padding(padding: EdgeInsetsGeometry.only(right: 12.w,top: 15.w),
                            child: GestureDetector(onTap: () {
                              print('忘记密码');
                            },child: Text('Forgot password',style: TextStyle(color: Color(0xff1E4BDF)),),),)
                          ),
                        ),
                        Gap(16.h),
                        Container(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              print('phonelogin测试');
                            },
                            child: Text("Phone Login >", style: TextStyle(color: Color(0xff1E4BDF)),),
                          ),
                        ),
                        Gap(36.h),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 28.h),
                          height: 42.h,
                          // width: 278.w,
                        //  padding: EdgeInsets.symmetric(horizontal: 50.w ,vertical: 7.h),
                          decoration: BoxDecoration(
                            // color: Color(0xff3161FF),
                            gradient: LinearGradient(colors: [
                              Color(0xff73C5FF),
                              Color(0xff3161FF),
                            ]),
                            borderRadius: BorderRadius.circular(20.h)
                          ),
                          child: IntrinsicWidth(
                            child: InkWell(
                              onTap: () {
                                
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 7.h),
                                child: Text('Log in',style: TextStyle(fontSize: 20.sp,color: Colors.white),)
                              ),
                            ),
                          ),
                        ),
                        Gap(16.h),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 28.h),
                          height: 42.h,
                          // width: 278.w,
                        //  padding: EdgeInsets.symmetric(horizontal: 50.w ,vertical: 7.h),
                          decoration: BoxDecoration(
                            // color: Color(0xff3161FF),
                            border: Border.all(color: Color(0xff1E4BDF)),
                            borderRadius: BorderRadius.circular(20.h)
                          ),
                          child: IntrinsicWidth(
                            child: InkWell(
                              onTap: () {
                                
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 7.h),
                                child: Text('Sign Up',style: TextStyle(fontSize: 20.sp,color: Color(0xff1E4BDF)),)
                              ),
                            ),
                          ),
                        ),
                        Gap(24.h),
                        Row(
                          children: [
                            Expanded(flex: 1,
                              child: 
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Color(0xffE6E6E6)
                                  )
                                )
                              ),
                            )
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text('Quick Logins',style: TextStyle(color: Color(0xff838383),fontSize: 14.sp),),
                            ),
                             Expanded(flex: 1,
                              child: 
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Color(0xffE6E6E6)
                                  )
                                )
                              ),
                            )
                            )
                          ],
                        ),
                        Gap(20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Assets.images.goggeIcon.path,width: 40.w,height: 40.h,),
                            Gap(50.w),
                            Image.asset(Assets.images.wechatIcon.path,width: 40.w,height: 40.h,),
                          ]
                        )
                        
                      ],
                    ),
                  ),
                  UserAgreement(),
                  Gap(50.h)
                ],
                
              ),
                 
              )
             ),
          ),
     

          //  Spacer(),
        ],
      ),
    );
  }
}
