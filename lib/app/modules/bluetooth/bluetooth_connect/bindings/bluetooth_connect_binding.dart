import 'package:get/get.dart';

import '../controllers/bluetooth_connect_controller.dart';

class BluetoothConnectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BluetoothConnectController>(
      () => BluetoothConnectController(),
    );
  }
}
