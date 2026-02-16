import 'package:get/get.dart';

import '../controllers/blue_user_controller.dart';

class BlueUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlueUserController>(
      () => BlueUserController(),
    );
  }
}
