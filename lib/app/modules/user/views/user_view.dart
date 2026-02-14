import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/modules/user/controllers/user_controller.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

class UserView extends BaseViews<UserController> {
  UserView({super.key});

  @override
  Widget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
      width: double.infinity,
      child: Column(
        children: [
          //顶部头像区域
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Row(
                children: [
                 Image.network(
                  SecureStorageService().getUserInfo()?.photo ?? '',
                  width: 58.w,
                  height: 58.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(Assets.images.userPhoto.path,
                     width: 58.w,
                  height: 58.w,
                  fit: BoxFit.cover,
                    );
                  },
                  ),
                  Gap(20.w),
                  Text(SecureStorageService().getUserInfo()?.name ?? ''),
                ],
              ),
              //  Gap(150.w),
              Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    Assets.images.group.path,
                    width: 22.w,
                    height: 24.h,
                  ),
                  Gap(5.h),
                  Image.asset(
                    Assets.images.right.path,
                    width: 20.w,
                    height: 15.h,
                  ),
                ],
              ),
            ],
          ),
          //Welcome
          Container(
            padding: EdgeInsets.symmetric(horizontal: 100.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: Text('Welcome'),
          ),
          Gap(10.h),
          //20Days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.amber),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '20',
                            style: TextStyle(
                              color: Color(0xff2b56d7),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          TextSpan(
                            text: 'Days',
                            style: TextStyle(
                              color: Color(0xff2b56d7),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' 15:12:23',
                            style: TextStyle(
                              color: Color(0xff2b56d7),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Online Duration'),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.amber),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '20',
                            style: TextStyle(
                              color: Color(0xff2b56d7),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          TextSpan(
                            text: 'Days',
                            style: TextStyle(
                              color: Color(0xff2b56d7),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' 15:12:23',
                            style: TextStyle(
                              color: Color(0xff2b56d7),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Training Duration'),
                  ],
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.w),
              // color: Colors.deepOrangeAccent,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: SingleChildScrollView(
                child: Column(
                children: [
                  //My Provide
                  InkWell(
                    onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'My Provider',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //Reminder Setting
                  InkWell(
                    onTap: () => Get.toNamed(Routes.SPLASH),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.reminder.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'Reminder Setting',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //Health Surveys
                  InkWell(
                    onTap: () => print('Myprovider点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame1.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'Health Surveys',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //Pain Record
                  InkWell(
                    onTap: () => print('Myprovider点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame2.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'Pain Record',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //Neural Record
                  InkWell(
                    onTap: () => print('Myprovider点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame3.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'Neural Record',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //ODI Questionare
                  InkWell(
                    onTap: () => print('Myprovider点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame4.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'ODI Questionare',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //Promis Questionare
                  InkWell(
                    onTap: () => print('Myprovider点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame5.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'Promis Questionare',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //Switch Units
                  InkWell(
                    onTap: () => print('Myprovider点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame6.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'Switch Units',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //Device Settings
                  InkWell(
                    onTap: () => print('Myprovider点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame7.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'Device Settings',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //Data Permissions
                  InkWell(
                    onTap: () => print('Data Permissions点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame8.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'Data Permissions',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //Our Website
                  InkWell(
                    onTap: () => print('Myprovider点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame2102.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'Our Website',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //About AIH
                  InkWell(
                    onTap: () => print('Myprovider点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame9.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'About AIH',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //Shop
                  InkWell(
                    onTap: () => print('Myprovider点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame10.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'Shop',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),

                  //Lanuage Settings
                  InkWell(
                    onTap: () => print('Myprovider点击测试'),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.images.frame11.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                              Gap(16.w),
                              Text(
                                'Lanuage Settings',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                          Image.asset(
                            Assets.images.right.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(16.h),
                
                ],
              ),
            
              )
            
            ),
          ),

          Container(

            margin: EdgeInsets.symmetric(horizontal: 70.w,vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 50.w,vertical: 7.h),

            decoration: BoxDecoration(
              
              borderRadius: BorderRadius.circular(21.h),
              border: Border.all(
                
                color: Color(0xff1e4bdf)
              )
            ),
            child: Text('log out',style: TextStyle(fontSize: 20.sp,color: Color(0xff1e4bdf)),),
          )
        ],
      ),
    );
  }
}
