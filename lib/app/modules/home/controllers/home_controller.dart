import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart';
import 'package:get/get.dart';
// import 'package:your_project/app/core/utils/bluetooth_util.dart'; // 調整成你的實際路徑
class HomeController extends BaseController {
  final RxList<ScanResult> foundDevices = <ScanResult>[].obs;
  final RxBool isScanning = false.obs;
  final RxString statusMessage = '就绪'.obs;

  @override
  void onInit() {
    super.onInit();
    // 监听 BluetoothUtil 的变化（如果你继续使用之前的 BluetoothUtil）
    ever(BluetoothUtil.scanResults.obs, (List<ScanResult> list) {
      foundDevices.assignAll(list);
      statusMessage.value = list.isEmpty ? '暂无设备' : '发现 ${list.length} 台设备';
    });

    ever(BluetoothUtil.isScanning.obs, (bool val) {
      isScanning.value = val;
    });
  }

  Future<void> startScan() async {
    try {
      statusMessage.value = '扫描中...';
      await BluetoothUtil.startScan(timeout: const Duration(seconds: 10));
    } catch (e) {
      statusMessage.value = '扫描失败：$e';
      Get.snackbar('错误', e.toString());
    }
  }

  Future<void> stopScan() async {
    await BluetoothUtil.stopScan();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await BluetoothUtil.aojConnectAndListen(
        device,
        onConnectionState: (state) {
          Get.back(); // 关闭 loading
          if (state == BluetoothConnectionState.connected) {
            Get.snackbar('连接成功', device.name);
            // 可跳转到下一页面
            // Get.to(() => DeviceDetailPage(device: device));
          } else if (state == BluetoothConnectionState.disconnected) {
            Get.snackbar('已断开', device.name);
          }
        },
        onData: (data) {
          print('收到数据: $data');
        },
      );
    } catch (e) {
      Get.back();
      Get.snackbar('连接失败', e.toString(), backgroundColor: Colors.red[100]);
    }
  }
}