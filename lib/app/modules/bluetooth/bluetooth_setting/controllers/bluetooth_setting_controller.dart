import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository_impl.dart';
import 'package:get/get.dart';

class BluetoothSettingController extends BaseController {
  final bluetoothOn = true.obs;
  final connectionStatus = 'Disconnected'.obs;
  final batteryStatus = 'Not charged'.obs;
  final batteryLevel = 0.obs;
  final measurementResults = 'No data'.obs;
  final currentMeasurementStatus = 'Idle'.obs;
  final selectedIntervalMinutes = 10.obs;

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

  void toggleBluetooth(bool value) => bluetoothOn.value = value;

  void setInterval(int minutes) => selectedIntervalMinutes.value = minutes;

  void measureHeartRate() {
    currentMeasurementStatus.value = 'Measuring...';
    // TODO: 调用 SDK 测心率
  }

  void measureBloodOxygen() {
    currentMeasurementStatus.value = 'Measuring...';
    // TODO: 调用 SDK 测血氧
  }

  void measureTemperature() {
    currentMeasurementStatus.value = 'Measuring...';
    // TODO: 调用 SDK 测体温
  }

  void getHealthData() {
    // TODO: 获取健康数据
    Get.snackbar('提示', 'Get Health Data');
  }

  void getSleepData() {
    // TODO: 获取睡眠数据
    Get.snackbar('提示', 'Get Sleep Data');
  }

  void getHardwareInfo() {
    // TODO: 获取硬件信息
    Get.snackbar('提示', 'Get Hardware Info');
  }

  /// 获取心率/测量间隔信息（getDeviceMeasureTime）
  Future<void> getDeviceMeasureTime() async {
    final repo = Get.isRegistered<BluetoothRepositoryImpl>()
        ? Get.find<BluetoothRepositoryImpl>()
        : BluetoothRepositoryImpl();
    final data = await repo.getDeviceMeasureTime();
    if (data == null || data.isEmpty) {
      Get.snackbar('提示', '获取心率间隔失败，请确保设备已连接');
      return;
    }
    final sb = StringBuffer()
      ..writeln('当前间隔: ${data['currentInterval'] ?? '-'} 分钟')
      ..writeln('默认间隔: ${data['defaultInterval'] ?? '-'} 分钟')
      ..writeln('可选间隔: ${data['intervalList'] ?? '-'}');
    Get.dialog(
      AlertDialog(
        title: Text('心率/测量间隔'),
        content: SingleChildScrollView(child: Text(sb.toString())),
        actions: [TextButton(onPressed: () => Get.back(), child: Text('确定'))],
      ),
    );
  }

  Future<void> instantMeasurement() async {
    final repo = Get.isRegistered<BluetoothRepositoryImpl>()
        ? Get.find<BluetoothRepositoryImpl>()
        : BluetoothRepositoryImpl();
    final data = await repo.instantMeasurement();
    if (data == null || data.isEmpty) {
      Get.snackbar('提示', '测量失败，请确保设备已连接');
      return;
    }
    print('当前结果 ：${data['result']}');
  }
}
