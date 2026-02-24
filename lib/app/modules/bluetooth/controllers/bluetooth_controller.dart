import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository_impl.dart';
import 'package:get/get.dart';

class BluetoothController extends BaseController {
  // 持有同一个 BluetoothUtil 实例（避免每次 new）
  final BluetoothUtil _bluetoothUtil = BluetoothUtil();
  final _bluetoothImpl = BluetoothRepositoryImpl();

  // ==================== 可观察变量 ====================
  final RxBool isScanning = false.obs; // 代替你原来的 textScan
  final RxList<ScanResult> scanResults = <ScanResult>[].obs;

  final RxBool isConnected = false.obs; // ← 新增
  BluetoothDevice? connectedDevice; // ← 新增（保存已连接设备）
  //扫描设备
  Future<void> startScan() async {
    // 1. 请求权限 + 自动开始扫描
    await _bluetoothUtil.requestBlePermissions();
    // 2. 监听实时设备列表（推荐方式）
    _bluetoothUtil.scanResultsStream.listen((results) {
      scanResults.assignAll(results); //自动更新 UI
      if (scanResults.isNotEmpty) {
        logger.d(scanResults[0]);

        logger.d(scanResults[0].device.advName);
        logger.d(scanResults[0].device.remoteId);

        print('已发现 ${scanResults.length} 个 AIZO RING 设备');
      }
    }); // 3. 15秒后自动停止扫描（可选）
    Future.delayed(const Duration(seconds: 15), () {
      _bluetoothUtil.stopScan();
      isScanning.value = false;
    });
  }


  Future<void> connectToDevice(ScanResult result) async {
     if (_bluetoothImpl.isConnected.value) {
      // connectedDevice = result.device;
      Get.snackbar('成功', '已经连接 AIZO RING', backgroundColor: Colors.green);
      return ;}
    final deviceMac = result.device.remoteId;
    final deviceName = result.device.platformName;

     await _bluetoothImpl.connectDevice(
      deviceMac: deviceMac.str,
    );
    
  }

  Future<void> notifyBoundDevice(ScanResult result) async {
     if (_bluetoothImpl.isBound.value) {
      Get.snackbar('成功', '已经绑定 AIZO RING', backgroundColor: Colors.green);
      return ;
    }
    if(!_bluetoothImpl.isConnected.value){
      connectToDevice(result);
    }
      final deviceMac = result.device.remoteId.str;
    final deviceName = result.device.platformName;
    
    await _bluetoothImpl.notifyBoundDevice(
      deviceName,
      deviceMac,
    );
     
  }



  //解除绑定
  Future<void> deviceBound() async {
    await _bluetoothImpl.deviceSet(2);
    
  }

  //获取当前活动目标 
  Future <void> getCurrentActivityGoals() async{
    _bluetoothImpl.getCurrentActivityGoals();
  }

  final count = 0.obs;
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

  void increment() => count.value++;
}
