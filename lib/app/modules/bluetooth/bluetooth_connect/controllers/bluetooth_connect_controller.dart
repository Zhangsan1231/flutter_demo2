import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/base/controller/bluetooth_controller.dart';
import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository_impl.dart';
import 'package:get/get.dart';

class BluetoothConnectController extends BaseController {
  /// 是否正在搜索（控制转圈显示）
  final searchBluetooth = false.obs;
  final foundDevices = <ScanResult>[].obs;

  /// 扫描持续秒数，到时间后自动停止并停止转圈
  static const int scanDurationSeconds = 10;

  Timer? _scanStopTimer;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // 进入页面自动开始搜索
    startScan();
  }

  @override
  void onClose() {
    _cancelScanTimer();
    if (searchBluetooth.value) {
      BluetoothUtil.stopScan();
      searchBluetooth.value = false;
    }
    super.onClose();
  }

  void _cancelScanTimer() {
    _scanStopTimer?.cancel();
    _scanStopTimer = null;
  }

  /// 开始搜索：转圈开始，[scanDurationSeconds] 秒后自动停止转圈
  Future<void> startScan() async {
    if (searchBluetooth.value) return;
    searchBluetooth.value = true;
    _cancelScanTimer();
    try {
      await BluetoothUtil.startScan(
        timeout: Duration(seconds: scanDurationSeconds),
      );
      _scanStopTimer = Timer(
        Duration(seconds: scanDurationSeconds),
        () {
          searchBluetooth.value = false;
          _scanStopTimer = null;
        },
      );
    } catch (e) {
      logger.e('startScan 失败: $e');
      searchBluetooth.value = false;
      _cancelScanTimer();
    }
  }

  /// 停止搜索：立即停止转圈
  Future<void> stopScan() async {
    _cancelScanTimer();
    try {
      await BluetoothUtil.stopScan();
    } catch (e) {
      logger.e('stopScan 失败: $e');
    }
    searchBluetooth.value = false;
  }

  Future<void> connect(BluetoothDevice device) async {
    await BluetoothUtil.connect(device);
  }

  /// 解绑当前已连接的 AOJ 设备（直接调原生 SDK，不依赖 BluetoothController 是否已注册）
  Future<void> unbindDevice() async {
    try {
      if (Get.isRegistered<BluetoothController>()) {
        await Get.find<BluetoothController>().disconnectAoj();
        return;
      }
      final repo = Get.isRegistered<BluetoothRepositoryImpl>()
          ? Get.find<BluetoothRepositoryImpl>()
          : BluetoothRepositoryImpl();
      final success = await repo.disconnectDevice();
      if (success) {
        Get.snackbar('提示', '解绑成功');
      } else {
        Get.snackbar('提示', '解绑失败，请重试');
      }
    } catch (e) {
      logger.e('解绑失败: $e');
      Get.snackbar('解绑失败', e.toString());
    }
  }
}
