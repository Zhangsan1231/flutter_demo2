import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/modules/user/user_profile/views/birthday_picker_ios.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/user_profile_controller.dart';

class UserProfileView extends BaseViews<UserProfileController> {
  @override
  Widget? appBar(BuildContext context) {
    // TODO: implement appBar
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.h),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.arrow_back_ios),
              Gap(100.w),
              Text(
                'Profile',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Gap(12.h),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Profile Picture
                  InkWell(
                    onTap: () {
                      // controller.uploadPhoto();
                      // controller.pickImage();
                      // logger.d('name点击测试');
                      // Get.toNamed(Routes.PROFILE_NAME);
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Profile Picture',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              //头像区域
                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  //Name
                  InkWell(
                    // onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                SecureStorageService.instance
                                        .getUserInfo()
                                        ?.name ??
                                    '',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  //UUID
                  InkWell(
                    // onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'UUID',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                SecureStorageService.instance
                                        .getUserInfo()
                                        ?.uuid ??
                                    '',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),

                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  //userID
                  InkWell(
                    // onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'User ID',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                SecureStorageService.instance
                                        .getUserInfo()
                                        ?.userId ??
                                    '',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  //Gender
                  InkWell(
                    // onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                SecureStorageService.instance
                                        .getUserInfo()
                                        ?.gender ??
                                    '',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  //Birthday
                  InkWell(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.r),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 16.h,
                          ),
                          child: BirthdayPicker(
                            selectedDate: controller.selectedBirthday,
                            label: 'Birthday',
                            isRequired: true,
                          ),
                        ),
                        isScrollControlled: true, // 允许自定义高度
                        backgroundColor: Colors.transparent,
                      );
                    },
                    // onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Birthday',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                SecureStorageService.instance
                                        .getUserInfo()
                                        ?.uuid ??
                                    '',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  //Phone Number
                  InkWell(
                    // onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                SecureStorageService.instance
                                        .getUserInfo()
                                        ?.phone ??
                                    '',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  //Email
                  InkWell(
                    // onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                SecureStorageService.instance
                                        .getUserInfo()
                                        ?.email ??
                                    '',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  // Address
                  InkWell(
                    // onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Address ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                SecureStorageService.instance
                                        .getUserInfo()
                                        ?.uuid ??
                                    '',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  //Height
                  InkWell(
                    // onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Height',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                SecureStorageService.instance
                                        .getUserInfo()
                                        ?.height
                                        .toString() ??
                                    '',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  //Weight
                  InkWell(
                    // onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Weight ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                SecureStorageService.instance
                                        .getUserInfo()
                                        ?.weight
                                        .toString() ??
                                    '',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  //SSN (last four digits)
                  InkWell(
                    // onTap: () =>Get.toNamed(Routes.USER_PROFILE),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SSN (last four digits)',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff666666),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                SecureStorageService.instance
                                        .getUserInfo()
                                        ?.weight
                                        .toString() ??
                                    '',
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Image.asset(
                                Assets.images.right.path,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Gap(24.h),
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 1.h,
                  ),
                  Gap(24.h),

                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Medical History',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff666666),
                      ),
                    ),
                  ),
                  Gap(10.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: TextField(
                      minLines: 5,
                      maxLines: 8,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            // onTap: controller.savePhoto,
            // onTap: controller.uploadPatchInfo,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 70.w, vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 7.h),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21.h),
                border: Border.all(color: Color(0xff1e4bdf)),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(fontSize: 20.sp, color: Color(0xff1e4bdf)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
