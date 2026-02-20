import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends BaseViews<ForgetPasswordController> {
  ForgetPasswordView({super.key}) : super(bgColor: Color(0xfffafafa));
  @override
  Widget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: Icon(Icons.arrow_back_ios),
      title: Text('重置密码'),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(40.h),
          Text(
            '请输入注册邮箱',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextField(
            controller: controller.forgetEmailController,
            decoration: InputDecoration(
              hintText: '请输入你的邮箱',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
              ),
            ),
          ),

          // InkWell(child: Container(
          //   padding: EdgeInsets.all(20.h),
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //       color: Colors.yellow
          //     )
          //   ),

          //   child: Text('发送验证码'),
          // ),),
          Gap(20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: controller.codeController,
                  decoration: InputDecoration(
                    hintText: '请输入验证码',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.h),
                    ),
                  ),
                ),
              ),
              Gap(12.w),
              InkWell(
                onTap: () async {
                  if (controller.frogetEmail.isEmpty) {
                    CherryToast.warning(title: Text('请输入邮箱')).show(context);
                  } else {
                    final resuilt = await controller.resetPasswordByPhoneCode();
                    print(resuilt);
                    if (resuilt) {
                      CherryToast.success(title: Text('验证码发送成功')).show(context);
                    } else {
                      CherryToast.warning(title: Text('验证码发送失败')).show(context);
                    }
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                  child: Text(
                    '发送验证码',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
          Gap(20.h),
          TextField(
            controller: controller.passwordController,
            decoration: InputDecoration(
              hintText: '请输入密码',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
              ),
            ),
          ),

          Gap(50.h),

          InkWell(
            onTap: () async {
              final result = await controller.resetPasswordByEmailCode();
              if (result) {
                CherryToast.success(
                  title: Text('重置密码成功,即将跳转登录页'),
                ).show(context);
                await Future.delayed(const Duration(milliseconds: 3500));

                Get.offNamed(Routes.LOGIN);
              } else {
                CherryToast.warning(title: Text('重置密码失败')).show(context);
                // 等待 Toast 显示完（加一点缓冲，比如 3.5 秒）
                // Get.offNamed(Routes.LOGIN);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50.w),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12.h),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Text(
                '重置密码',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
