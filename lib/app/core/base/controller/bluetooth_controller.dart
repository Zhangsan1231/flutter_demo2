import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/model/aoj_constants.dart';
import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository_impl.dart';
import 'package:get/get.dart';

// import 'package:flutter_demo2/app/core/model/aoj_constants.dart'; // 假设你的常量在这里
// import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart'; // 你的工具类

class BluetoothController extends BaseController {
  // ──────────────────────────────────────────────
  //  observable 状态
  // ──────────────────────────────────────────────
  final RxBool isBluetoothReady = false.obs;
  final RxBool isScanning = false.obs;
  final RxList<ScanResult> discoveredDevices = <ScanResult>[].obs;

  final Rx<BluetoothDevice?> connectedDevice = Rx<BluetoothDevice?>(null);
  final Rx<BluetoothConnectionState> connectionState =
      BluetoothConnectionState.disconnected.obs;

  final RxBool isAojConnected = false.obs;
  final RxList<int> latestAojData = <int>[].obs;

  // 用于 AOJ 专用连接（如果你只连接一台 AOJ 设备）
  BluetoothDevice? _aojDevice;

  // 记录上一次更新的时间，避免高频更新 UI
  DateTime? _lastUiUpdateTime;

  // ──────────────────────────────────────────────
  // 生命周期
  // ──────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _initBluetooth();
    // 监听 BluetoothUtil 内部的变化（如果工具类暴露了 Rx 变量）
    ever(BluetoothUtil.scanResults, (_) {
      discoveredDevices.assignAll(BluetoothUtil.scanResults);
    });
    ever(BluetoothUtil.isScanning.obs, (val) {
      isScanning.value = val == true;
    });
  }

  @override
  void onClose() {
    // 建议在这里做比较彻底的清理
    BluetoothUtil.dispose();
    super.onClose();
  }

  // ──────────────────────────────────────────────
  // 初始化 & 权限
  // ──────────────────────────────────────────────
  Future<void> _initBluetooth() async {
    final success = await BluetoothUtil.init();
    isBluetoothReady.value = success;

    if (!success) {
      Get.snackbar('提示', '蓝牙初始化失败，请检查权限');
    }
  }

  Future<bool> ensureBluetoothReady() async {
    if (!isBluetoothReady.value) {
      await _initBluetooth();
    }
    return isBluetoothReady.value;
  }

  // ──────────────────────────────────────────────
  // 扫描相关
  // ──────────────────────────────────────────────
  Future<void> startScan({
    Duration timeout = const Duration(seconds: 8),
    List<Guid>? withServices,
  }) async {
    if (!await ensureBluetoothReady()) return;

    try {
      await BluetoothUtil.startScan(
        timeout: timeout,
        withServices: withServices,
      );
    } catch (e) {
      Get.snackbar('扫描错误', e.toString());
    }
  }

  Future<void> stopScan() async {
    try {
      await BluetoothUtil.stopScan();
    } catch (e) {
      print('停止扫描失败: $e');
    }
  }

  // ──────────────────────────────────────────────
  // 通用连接 / 断开
  // ──────────────────────────────────────────────
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      // 先检查是否已连接，避免重复连接
      if (connectedDevice.value == device &&
          connectionState.value == BluetoothConnectionState.connected) {
        logger.d('设备已连接，无需重复连接');
        return true;
      }
      logger.d('开始连接设备: ${device.platformName} (${device.remoteId.str})');
      await BluetoothUtil.connect(device);
      connectedDevice.value = device;
      logger.d('flutter_blue_plus 连接成功');
      // 连接成功后，立即通知 SDK 绑定（这里调用 repository）
      final repo = Get.find<BluetoothRepositoryImpl>(); // 或注入进来
      final boundSuccess = await repo.notifyBoundDevice(
        deviceName: device.platformName ?? 'AIZO RING',
        deviceMac: device.remoteId.str,
      );
      if (boundSuccess) {
        isAojConnected.value = true;
        logger.d('SDK 绑定通知成功');
      } else {
        logger.w('SDK 绑定通知返回 false，后续可能有问题');
      }
      // 监听连接状态变化
      device.connectionState.listen((state) {
        connectionState.value = state;
        if (state == BluetoothConnectionState.disconnected) {
          connectedDevice.value = null;
          Get.snackbar('设备断开', device.name.isEmpty ? '未知设备' : device.name);
        }
      });
      return true;
    } catch (e) {
      Get.snackbar('连接失败', e.toString());
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await BluetoothUtil.disconnect();
    connectedDevice.value = null;
    connectionState.value = BluetoothConnectionState.disconnected;
  }

  // ──────────────────────────────────────────────
  // AOJ 专用连接方式（推荐使用）
  // ──────────────────────────────────────────────
  Future<void> connectAojByMac(
    String macAddress, {
    bool showLoading = true,
  }) async {
    if (showLoading) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }

    BluetoothDevice? device;

    try {
      // 1. 从已扫描结果中找设备（复用你原有的逻辑）
      final targetResult = BluetoothUtil.scanResults.firstWhereOrNull(
        (r) => r.device.remoteId.str.toUpperCase() == macAddress.toUpperCase(),
      );

      if (targetResult == null) {
        throw Exception('未找到 MAC 为 $macAddress 的设备，请重新扫描');
      }

      device = targetResult.device;

      // 2. 建立底层 GATT 连接
      // await device.connect(

      //   timeout: const Duration(seconds: 20),
      //   autoConnect: false, license: free,
      // );
      await device.connect(
        timeout: const Duration(seconds: 20),
        autoConnect: false,
        license: License.free, // ← 这里 free 没定义
      );

      // 更新状态
      isAojConnected.value = true;
      connectionState.value = BluetoothConnectionState.connected;
      _aojDevice = device;

      print('GATT 连接成功: ${device.platformName ?? "未知"} ($macAddress)');

      // 3. 关键步骤：通知 AIZO SDK 绑定这个设备
      final repo =
          BluetoothRepositoryImpl(); // 或 Get.find<BluetoothRepository>()
      final boundSuccess = await repo.notifyBoundDevice(
        deviceName: device.platformName ?? 'AIZO RING',
        deviceMac: device.remoteId.str,
      );

      print('notifyBoundDevice 调用结果: $boundSuccess');

      if (boundSuccess) {
        Get.snackbar('连接成功', '已连接并通知 SDK 绑定');
      } else {
        Get.snackbar('警告', '蓝牙已连，但 SDK 绑定通知失败');
        print('警告：SDK 绑定返回 false，后续功能可能异常');
      }

      // 4. 立即测试 SDK 是否能正常工作（强烈推荐）
      final power = await repo.getCurrentPowerState();
      if (power != null && power['electricity'] != null) {
        print(
          'SDK 返回电量: ${power['electricity']}% , 充电状态: ${power['workingMode']}',
        );
        Get.snackbar('测试成功', '电量: ${power['electricity']}%');
      } else {
        print('SDK 获取电量失败，可能握手未完成');
      }

      // 5. 监听底层被动断开（保持你的原逻辑）
      device.connectionState.listen((state) {
        connectionState.value = state;
        isAojConnected.value = state == BluetoothConnectionState.connected;

        if (state == BluetoothConnectionState.disconnected) {
          _aojDevice = null;
          Get.snackbar('AOJ断开', '设备已断开连接');
          print('设备被动断开');
        }
      });
    } catch (e) {
      print('AOJ连接失败: $e');
      Get.snackbar('AOJ连接失败', e.toString().split('\n').first);

      // 清理
      try {
        await device?.disconnect();
      } catch (_) {}
      isAojConnected.value = false;
      connectionState.value = BluetoothConnectionState.disconnected;
    } finally {
      if (showLoading) Get.back();
    }
  }

  Future<void> disconnectAoj() async {
    await BluetoothUtil.aojDisconnect();
    isAojConnected.value = false;
    _aojDevice = null;
  }

  // ──────────────────────────────────────────────
  // 常用快捷方法（根据实际业务补充）
  // ──────────────────────────────────────────────

  /// 获取当前连接的 AOJ 设备的 Notify 特征（如果需要手动写/读）
  Future<BluetoothCharacteristic?> getAojNotifyCharacteristic() async {
    if (_aojDevice == null) return null;

    final services = await _aojDevice!.discoverServices();
    for (var svc in services) {
      if (svc.uuid == AOJConstants.serviceUUID) {
        for (var char in svc.characteristics) {
          if (char.uuid == AOJConstants.notifyUUID) {
            return char;
          }
        }
      }
    }
    return null;
  }

  /// 示例：向 AOJ 写入指令（如果你的设备支持 write）
  Future<void> writeToAoj(List<int> command) async {
    final char = await getAojNotifyCharacteristic();
    if (char == null || !char.properties.write) {
      throw Exception('不支持写入或未找到特征');
    }
    await BluetoothUtil.writeCharacteristic(char, command);
  }
}
