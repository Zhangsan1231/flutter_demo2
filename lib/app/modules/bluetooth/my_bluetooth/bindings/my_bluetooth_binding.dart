import 'package:get/get.dart';

import '../controllers/my_bluetooth_controller.dart';

class MyBluetoothBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBluetoothController>(
      () => MyBluetoothController(),
    );
  }
}
