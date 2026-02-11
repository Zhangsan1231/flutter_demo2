import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/data/model/user_model.dart';
import 'package:flutter_demo2/app/data/repository/default_repository_impl.dart';
import 'package:get/get.dart';

class UserController extends BaseController {
  
  //获取用户头像
  Future<void> userInfo() async {
   UserModel? userModel = await DefaultRepositoryImpl().getInfo();
   logger.d('userModel?.phone.toString() ${userModel?.phone.toString()}');
  }

}