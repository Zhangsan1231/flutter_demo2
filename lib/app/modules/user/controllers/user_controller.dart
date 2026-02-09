import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:get/get.dart';

class UserController extends BaseController {
  //TODO: Implement UserController

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
