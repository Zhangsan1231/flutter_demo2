import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/data/repository/auth_repository_impl.dart';

class ForgetPasswordController extends BaseController {

  final forgetEmailController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();


  String get frogetEmail => forgetEmailController.text.trim();
    String get code => codeController.text.trim();

  String get password => passwordController.text.trim();

  //发送邮件（forgetEmail 返回的是 bool，不是 200）
  Future<bool> resetPasswordByPhoneCode() async {
    return await AuthRepositoryImpl().forgetEmail(frogetEmail);
  }

  Future<bool> resetPasswordByEmailCode() async{
    final result = await AuthRepositoryImpl().resetPasswordByEmailCode(frogetEmail,code,password);
    if(result ==200){
      return true;
    }
    return false;
    
  }

  

}