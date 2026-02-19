import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart';
import 'package:get/get.dart';

class BluetoothConnectController extends BaseController {
  final searchBluetooth = false.obs;
  final foundDevices = <ScanResult>[].obs; // 推荐自己维护一个 RxList

  // RxBool searchBluetooth = true.obs;
  // final blueUtil = BluetoothUtil();
Future<void> startScan() async {
  BluetoothUtil.startScan();
}

Future<void> stopScan() async {
  BluetoothUtil.stopScan();
}
Future<void> connect(BluetoothDevice device) async {
  BluetoothUtil.connect( device);
}

  @override
  void onInit() {
    super.onInit();
  }
}
