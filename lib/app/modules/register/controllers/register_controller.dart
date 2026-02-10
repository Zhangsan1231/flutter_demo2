import 'package:authing_sdk/client.dart';
import 'package:authing_sdk/result.dart';
import 'package:authing_sdk/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:get/get.dart';

class RegisterController extends BaseController {
  //TODO: Implement RegisterController

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxString errorText = ''.obs;
  // RxString password = ''.obs;
  // RxString confirmPassword = ''.obs;
  RxBool isValid = false.obs;
  RxBool isRegister = false.obs;
  RxBool registerAgreement = false.obs;

  String get email => emailController.text.trim();
  String get password => passwordController.text.trim();

  void confirmPassword(String value) {
    if (value.isEmpty) {
      errorText.value = '请再次输入密码';
    } else if (password != value) {
      errorText.value = '密码与上次输入不对';
    } else {
      errorText.value = '';
      isRegister.value = true;
    }
  }

  Future<void> RegisterButton() async {
    if (SecureStorageService().getBool(AppValues.agreementValue) == false) {
      Get.snackbar('', '请同意用户协议');
    } else if (isRegister.value) {
      AuthResult result = await AuthClient.registerByEmail(email, password);
      User? user = result.user;
      logger.d('注册打印测试${result.code}');
      logger.d('注册打印测试${result.message}');
      logger.d(result.user?.id);
      logger.d(result.user?.token);

      // AuthClient.registerByEmail(email.value, password.value);
      Get.snackbar('注册成功', '');
      // Get.toNamed(Routes.LOGIN);
    } else {
      Get.snackbar('失败', '请输入账号or密码');
    }
    // if(isRegister.value){
    //   AuthClient.registerByEmail(email.value, password.value);
    //   logger.d('登录成功${email.value} -----${password.value}');
    //   Get.snackbar('', '登录成功');

    // }else{
    //   if(errorText.value == '' || errorText.value.isEmpty){
    //     Get.snackbar('登录失败', '请输入账号or密码');
    //   }else{
    //     Get.snackbar('登录失败', errorText.value);
    //   }
    //   print('登录失败');
    // }
  }

  void validatePassword(String value) {
    // password.value = value;

    // 重置
    errorText.value = '';
    isValid.value = false;

    if (value.isEmpty) {
      errorText.value = '請輸入密碼';
      return;
    }

    if (value.length < 8) {
      errorText.value = '密碼至少需要 8 個字符';
      return;
    }

    // 統計滿足的類型數量
    int typesCount = 0;

    if (RegExp(r'[a-z]').hasMatch(value)) typesCount++;
    if (RegExp(r'[A-Z]').hasMatch(value)) typesCount++;
    if (RegExp(r'[0-9]').hasMatch(value)) typesCount++;
    if (RegExp(r'[!@#\$%^&*]').hasMatch(value)) typesCount++;

    if (typesCount < 3) {
      errorText.value = '需包含至少 3 種字符類型（小寫、大寫、數字、特殊字符）';
      return;
    }

    // 全部通過
    isValid.value = true;
    errorText.value = '';
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  void emailText(String email) {
    if (email.trim().isEmpty) {
      errorText.value = '请输入邮箱地址';
    } else if (!isValidEmail(email)) {
      errorText.value = '邮箱格式不正确';
    } else {
      errorText.value = '';
    }
  }
}
