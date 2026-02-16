import 'package:get/get.dart';

import '../controllers/bluetooth_devices_controller.dart';

class BluetoothDevicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BluetoothDevicesController>(
      () => BluetoothDevicesController(),
    );
  }
}
