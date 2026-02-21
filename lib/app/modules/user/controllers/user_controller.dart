import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/data/model/user_model.dart';
import 'package:flutter_demo2/app/data/repository/auth_repository_impl.dart';
import 'package:flutter_demo2/app/data/repository/default_repository_impl.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class UserController extends BaseController {


  //注销
  Future<void> logout() async {
    AuthRepositoryImpl().logout();
    SecureStorageService().deleteAll();
    Get.toNamed(Routes.LOGIN);
  }

Future<void> _ensureUserInitialized() async{
 await AuthRepositoryImpl().ensureUserInitialized();
}
  @override
  void onInit() {
    super.onInit();

  _ensureUserInitialized();
  }
  @override
  void onReady() {
    super.onReady();
    _ensureUserInitialized();
    // 這裡每次頁面顯示時都會執行（當使用 Get.to / Get.off 等導航）
  }
  
  

  
}
