import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/modules/user/user_profile/controllers/user_profile_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ProfileNameView extends BaseViews<UserProfileController> {
  @override
  Widget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏（无 AppBar，手动实现）
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 返回箭头
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 24.sp,
                      color: Colors.black87,
                    ),
                    onPressed: () => Get.back(),
                  ),

                  // Done 按钮
                  TextButton(
                    onPressed: () {
                      // 保存逻辑或返回
                      Get.back();
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              
              decoration: BoxDecoration(color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.h)),
              child: Column(
                children: [
                  TextField(
                    // controller: controller.firstNameController,
                    decoration: InputDecoration(
                      hintText: 'First name',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                    ),
                    style: TextStyle(fontSize: 16.sp),
                  ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey)
                      ),
                    ),
                  TextField(
                    // controller: controller.firstNameController,
                    decoration: InputDecoration(
                      hintText: 'First name',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                    ),
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
