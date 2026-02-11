import 'package:authing_sdk/client.dart';
import 'package:authing_sdk/result.dart';
import 'package:authing_sdk/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/data/repository/auth_repository_impl.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl();
  SecureStorageService storage = SecureStorageService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // / 方便获取值的方法（可选）
  String get email => emailController.text.trim();
  String get password => passwordController.text.trim();
  // AuthRepositoryImpl authImpl = AuthRepositoryImpl();
  //登录
  Future<void> Login() async {
    String result = await authRepositoryImpl.loginEmailAndPassword(
      email,
      password,
    );
    logger.d('11111111111111$result');
    if (result == '登录成功') {
      //登录成功后确保用户数据初始化
      bool userInitSuccess = await authRepositoryImpl.ensureUserInitialized();
      logger.d('1222222222222222$userInitSuccess');
      if (userInitSuccess) {
        final user = storage.getUserInfo();
        logger.d('user.name = ${user?.name}');
        logger.d('userBithdate:${user?.birthdate}');
        if (user?.name == 'defualtName'){
          Get.toNamed(Routes.INFORMATION);
        }

        // logger.d('storage.getUserInfo() ================${storage.getUserInfo()?.name}');
        // if(storage.getUserInfo()?.name ==null ) Get.toNamed(Routes.INFORMATION);
        // logger.d("userInitSuccess:$userInitSuccess");
        //展示弹窗
        // Get.offNamed(Routes.NAVIGATION);
      } else {
        logger.d('未查询到数据');
      }
    } else {
      logger.d('登录失败');
    }
    //  final emailValue = email;
    //   final passwordValue = password;

    //   print('邮箱: $emailValue');
    //   print('密码: $passwordValue');
    //   AuthResult result = await AuthClient.loginByAccount(emailValue,passwordValue);
    //   User? user = result.user; // user info
    //   logger.d(result.code);
    //   logger.d(user?.token);
    // if(user!.token.isNotEmpty){
    //   SecureStorageService.instance.setAccessToken(accessToken)
    // }
  }

  //获取账号
  void accountText() {}
}
