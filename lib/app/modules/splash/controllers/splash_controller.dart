import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/data/repository/auth_repository_impl.dart';
import 'package:get/get.dart';

class SplashController extends BaseController {
  //TODO: Implement
  

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    
    
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
