import 'package:get/get.dart';

import '../controllers/connect_device_controller.dart';

class ConnectDeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConnectDeviceController>(
      () => ConnectDeviceController(),
    );
  }
}
