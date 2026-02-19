import 'package:get/get.dart';

import '../controllers/bluetooth_setting_controller.dart';

class BluetoothSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BluetoothSettingController>(
      () => BluetoothSettingController(),
    );
  }
}
