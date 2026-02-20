// 导入 Flutter 核心库
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/modules/login/controllers/auth_controller.dart';
import 'package:flutter_demo2/app/modules/login/controllers/login_controller.dart';

// 导入自定义的登录页面横幅组件
import 'package:flutter_demo2/app/modules/login/widget/login_banner.dart';

// 导入用户协议组件
import 'package:flutter_demo2/app/modules/login/widget/user_agreement.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';

// 导入通过 flutter_gen 生成的资源路径类（图片、svg等）
import 'package:flutter_demo2/gen/assets.gen.dart';

// 导入 flutter_screenutil，用于屏幕适配（.w .h .sp 等单位）
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 导入 gap 插件，用于方便添加间距（代替 SizedBox）
import 'package:gap/gap.dart';

// 导入 GetX 的核心功能（Get.dialog, Get.snackbar 等）
import 'package:get/get.dart';

// 导入 logger，用于调试打印（本文件中未使用，但保留导入）
import 'package:logger/web.dart';

// 定义登录页面主组件，使用 StatefulWidget 因为内部可能会有状态变化
class LoginWidget extends StatefulWidget {
  // 构造函数，允许传入 key
  const LoginWidget({Key? key}) : super(key: key);

  // 创建对应的 State 对象
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

// 登录页面的状态类
class _LoginWidgetState extends State<LoginWidget> {
  final c = Get.find<LoginController>();
  RxBool loginAgreement = false.obs;
  // 构建 UI 的核心方法，返回 Widget 树
  @override
  Widget build(BuildContext context) {
    // 最外层 Container，宽度占满屏幕
    return Container(
      width: double.infinity,                    // 宽度撑满父容器
      // 主布局：垂直排列，从上到下
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,  // 子组件水平居中
        mainAxisAlignment: MainAxisAlignment.start,     // 从顶部开始排列
        children: [
          // 显示顶部横幅组件（通常是 Logo 或欢迎文字/图片）
          const LoginBanner(),
          Gap(30.h),                             // 横幅与下方内容之间 30 高度间距（适配单位）

          // Expanded 让下方卡片区域占据剩余所有垂直空间
          Expanded(
            // 白色卡片容器
            child: Container(
              width: double.infinity,                // 宽度占满
              // 背景白色 + 顶部左右圆角，形成悬浮卡片效果
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.h),    // 左上圆角
                  topRight: Radius.circular(24.h),   // 右上圆角
                ),
              ),
              // 使用 SingleChildScrollView 防止键盘弹出时内容被遮挡
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 32.h), // 内部顶部额外 32 间距
                // 滚动物理效果：iOS 风格的弹性反弹
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // 表单内容区域，左右两侧留出安全边距
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        // 内容从左开始对齐（标题左对齐）
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // “账号”标题
                          Text(
                            'Account Number',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,   // 半粗体
                              fontSize: 18.sp,               // 适配字体大小
                              color: Colors.black87,         // 深灰黑色
                            ),
                          ),
                          Gap(16.h),                         // 标题与输入框间距

                          // 账号输入框
                          AccountText(),
                          Gap(21.h),                         // 账号与密码标题间距

                          // “密码”标题
                          Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              color: Colors.black87,
                            ),
                          ),
                          Gap(16.h),                         // 标题与输入框间距

                          // 密码输入框（带忘记密码链接）
                          PasswordText(),
                          Gap(16.h),

                          // 手机登录文字链接
                          PhoneLogin(),
                          Gap(36.h),                         // 与下方登录按钮较大间距

                          // 登录按钮
                          LoginButton(),
                          Gap(16.h),

                          // 注册按钮
                          SignUpButton(),

                          Gap(24.h),

                          // 快速登录分割线 + 文字
                          QuickText(),
                          Gap(20.h),

                          // 第三方登录图标
                          LoginIcons(),
                        ],
                      ),
                    ),

                    // 用户协议组件区域，左右小边距
                    // Obx(() => Container(
                    //   margin: EdgeInsets.only(left: 10.w, right: 4.w),
                    //   child: UserAgreement(agreementValue:loginAgreement,),
                    // ),),

                    Gap(50.h),                           // 页面最底部留白
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 账号输入框组件
  Widget AccountText() {
    return TextField(
      controller: c.emailController,
      decoration: InputDecoration(
        filled: true,                              // 启用背景填充
        fillColor: const Color(0xffF2F2F2),        // 极浅灰色背景
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.h), // 圆角 12
          borderSide: BorderSide.none,               // 移除边框线
        ),
        hintText: 'Please enter your account number', // 占位文字
        hintStyle: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[500],                   // 灰色提示文字
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,                          // 左右内边距
          vertical: 12.h,                            // 上下内边距
        ),
      ),
      // TODO: 后续可添加 controller、onSubmitted、focusNode 等
    );
  }

  // 密码输入框组件
  Widget PasswordText() {
    return TextField(
      controller: c.passwordController,
      obscureText: true,                           // 隐藏输入内容（显示为点）
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.h),
          borderSide: BorderSide.none,
        ),
        hintText: 'Please enter your password',
        hintStyle: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[500],
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        // 右侧附加组件：忘记密码文字
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 12.w),   // 右边距
          child: GestureDetector(
            onTap: () {
              Get.toNamed(Routes.FORGET_PASSWORD);
              // showForgotPasswordDialog();           // 点击弹出重置密码弹窗
              print('用户点击了“忘记密码”');
            },
            child: Text(
              'Forgot password',
              style: TextStyle(
                color: const Color(0xff1E4BDF),      // 蓝色
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(), // 防止文字被压缩
      ),
      
    );
  
  }

  // 忘记密码弹窗方法
  void showForgotPasswordDialog() {
    final hasText = false.obs;
    final emailController = TextEditingController();   // 创建邮箱输入控制器
    final errorText = ''.obs;                          // 响应式错误提示文本

    Get.dialog(                                        // 显示 GetX 对话框
      AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 80.h), // 四周边距
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),   // 对话框圆角
        ),
        contentPadding: EdgeInsets.zero,               // 移除默认内边距，自己控制
        backgroundColor: Colors.white,
        content: Container(
          width: double.maxFinite,                     // 宽度占满可用空间
          padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h), // 内部四周边距
          child: SingleChildScrollView(                // 防止内容过多可滚动
            child: Column(
              mainAxisSize: MainAxisSize.min,          // 高度自适应内容
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(8.h),
                Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff333333),
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(14.h),
                Text(
                  "We will send you an email to reset your password.",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff666666),
                    height: 1.4,                       // 行高更舒适
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(24.h),

                // 邮箱输入框，使用 Obx 响应式更新 errorText
                Obx(
                  () { 
                                            final controller = Get.find<LoginController>();

                    return TextField(
                    controller: controller.forgetEmailController,
                    keyboardType: TextInputType.emailAddress, // 邮箱键盘
                    autofocus: true,                      // 自动聚焦
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffF2F2F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.h),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Please enter your email address',
                      hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                      errorText: errorText.value.isEmpty ? null : errorText.value,
                      errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 11.sp),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    ),
                    onChanged: (value) {
                      hasText.value = value.trim().isNotEmpty;

                      // 输入时如果有错误且现在有内容，清除错误提示
                      if (errorText.value.isNotEmpty && value.trim().isNotEmpty) {
                        errorText.value = '';
                      }
                    },
                  );}
                ),

                Gap(24.h),

                // OK 按钮容器 - 全宽
                SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    return   Container(
                    decoration: BoxDecoration(
                      color: hasText.value? Color(0xff2B56D7) : Color(0x732B56D7),   // 半透蓝色背景
                      borderRadius: BorderRadius.circular(20.h),
                    ),
                    child: InkWell(
                      onTap: () async {   
                        final controller = Get.find<LoginController>();
                                       // 点击事件 - 异步处理
                        // final email = emailController.text.trim(); // 去除首尾空格
                       
                       
                        controller.forgetPassword();
                        Get.back();                      // 校验通过 → 关闭弹窗

                        
                      },
                      borderRadius: BorderRadius.circular(20.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                
                  }) 
                ),
                Gap(12.h),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,                      // 点击外部空白区域可关闭弹窗
    );
  }

  // 手机登录快捷入口
  Widget PhoneLogin() {
    return Container(
      margin: EdgeInsets.only(right: 34 - 25.w),     // 右边距微调
      alignment: Alignment.centerRight,              // 整体靠右
      child: InkWell(
        onTap: () {
          print('用户点击了 Phone Login');
          // TODO: 跳转手机登录页面
        },
        child: Text(
          "Phone Login >",
          style: TextStyle(
            color: const Color(0xff1E4BDF),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // 登录按钮
  Widget LoginButton() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 28.h),
      height: 42.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(             // 左右渐变背景
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xff73C5FF), Color(0xff3161FF)],
        ),
        borderRadius: BorderRadius.circular(20.h),
      ),
      child: InkWell(
        onTap: c.Login,
        borderRadius: BorderRadius.circular(20.h),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7.h),
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            'Log in',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // 注册按钮
  Widget SignUpButton() {
    // 这里注入 Controller（只注入一次）
    // Get.put(AuthController());  // ← 加这一行！
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 28.h),
      height: 42.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff1E4BDF), width: 1.5), // 蓝色描边
        borderRadius: BorderRadius.circular(20.h),
      ),
      child: InkWell(
        onTap: () {
          // Get.find<AuthController>().login();
          // c.auth0Login();
          Get.toNamed(Routes.REGISTER);
          print('用户点击了 注册 按钮');
          // TODO: 跳转注册页面
        },
        borderRadius: BorderRadius.circular(20.h),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7.h),
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 20.sp,
              color: const Color(0xff1E4BDF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // 快速登录分割线 + 文字
  Widget QuickText() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xffE6E6E6),        // 浅灰分割线
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          child: Text(
            'Quick Logins',
            style: TextStyle(
              color: const Color(0xff838383),
              fontSize: 14.sp,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xffE6E6E6),
          ),
        ),
      ],
    );
  }

  // 第三方登录图标区域
  Widget LoginIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,   // 图标居中排列
      children: [
        Image.asset(
          Assets.images.goggeIcon.path,              // Google 图标（注意拼写：gogge → google?）
          width: 40.w,
          height: 40.h,
        ),
        Gap(50.w),                                   // 图标间距
        Image.asset(
          Assets.images.wechatIcon.path,             // 微信图标
          width: 40.w,
          height: 40.h,
        ),
      ],
    );
  }
}