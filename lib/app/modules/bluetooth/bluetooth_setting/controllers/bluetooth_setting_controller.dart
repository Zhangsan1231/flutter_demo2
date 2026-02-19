import 'package:flutter_demo2/app/core/base/base_controller.dart';
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
}
