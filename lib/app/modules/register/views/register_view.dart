import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/modules/login/widget/user_agreement.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../controllers/register_controller.dart';

class RegisterView extends BaseViews<RegisterController> {
  RegisterView({super.key})
    : super(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // 看圖片顏色決定
      );

  @override
  Widget? appBar(BuildContext context) {
    // TODO: implement appBar
    return null;
  }

  final RxBool _obscureText = true.obs;
  final RxBool _obscureTextTwo = true.obs;

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        children: [
          Container(
            // alignment: Alignment.center,
            child: Stack(
              // alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0.w,

                  child: Center(child: Icon(Icons.arrow_back, size: 20.sp)),
                ),
                // 标题文字 - 自动居中
                Center(
                  child: Text(
                    '注册',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30.sp, // 建议加上字号
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(20.h),
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '邮箱',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Gap(20.h),
              Container(
                child: TextField(
                  controller: controller.emailController,
                    // obscureText: true, // 如果是密碼才開啟
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffF2F2F2),
                     

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.h),
                        borderSide: BorderSide.none,
                      ),

                      hintText: '请输入你的邮箱',
                      hintStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    // 補全 keyboardType
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              
              Gap(20.h),
              //密码
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '密码',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
              ),
              Gap(20.h),
              //密码输入
              Container(
                child: Obx(
                  () => TextField(
                    controller: controller.passwordController,
                    obscureText: _obscureText.value, // 动态控制是否隐藏
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffF2F2F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.h),
                        borderSide: BorderSide.none,
                      ),
                      
                      hintText: '请输入你的密码',
                      hintStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      
                      suffixIcon: IconButton(
                        onPressed: () {
                          _obscureText.value = !_obscureText.value;
                        },
                        icon: Icon(
                          _obscureText.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    // onChanged: controller.validatePassword
                    
                  ),
                  // 補全 keyboardType
                  // keyboardType: TextInputType.emailAddress,
                ),
              ), // 密码规则提示文字
              // 推荐：使用多行字符串 + 三引号
              Text('''
至少8个字符，包含以下4种字符中至少3种：
小写字母（a-z）、大写字母（A-Z）、数字（0-9）、特殊字符（！@#\%^&*）
''', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600], height: 1.5)),

              //密码
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '确认密码',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Gap(20.h),
              //密码
              Container(
                child: Obx(
                  () => TextField(
                    obscureText: _obscureTextTwo.value, // 动态控制是否隐藏
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffF2F2F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.h),
                        borderSide: BorderSide.none,
                      ),

                      hintText: '请确认你的新密码',
                      hintStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _obscureTextTwo.value = !_obscureTextTwo.value;
                        },
                        icon: Icon(
                          _obscureTextTwo.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    onChanged: controller.confirmPassword,
                  ),
                  // 補全 keyboardType
                  // keyboardType: TextInputType.emailAddress,
                ),
              ),
              
              Obx(() => Container(
                alignment: Alignment.bottomLeft,
                child: Text(controller.errorText.value,style: TextStyle(color: Colors.red),),
              )),
            ],
          ),

          Gap(10.h),

          UserAgreement(),
          // Obx(() => UserAgreement(agreementValue: controller.registerAgreement),),
          Gap(20.h),
          InkWell(
            onTap: controller.RegisterButton,
            child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.h),
              color: const Color.fromARGB(255, 92, 161, 217),
            ),
            child: Text('注册'),
          ),
        
          )
        ],
      ),
    );
  }
}
