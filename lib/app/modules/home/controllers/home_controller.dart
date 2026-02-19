import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/base/controller/bluetooth_controller.dart';
import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository_impl.dart';
import 'package:get/get.dart';
// import 'package:your_project/app/core/utils/bluetooth_util.dart'; // 調整成你的實際路徑
class HomeController extends BaseController {
  final blueImpl = BluetoothRepositoryImpl(); // 安卓端 MethodChannel
  final blueCtrl = BluetoothController();     // flutter_blue_plus 工具

  Future<void> connect() async {
    logger.d('开始连接流程...');

    // 第一步：初始化 SDK（安卓端）
    final initSuccess = await blueImpl.init();
    if (initSuccess != true) {
      logger.e('SDK 初始化失败');
      Get.snackbar('错误', 'SDK 初始化失败');
      return;
    }
    logger.d('SDK 初始化成功');

    // 第二步：确保蓝牙已打开（简单检查）
    final isReady = await blueCtrl.ensureBluetoothReady();
    if (!isReady) {
      logger.e('蓝牙未准备好');
      Get.snackbar('提示', '请打开蓝牙并授予权限');
      return;
    }
    logger.d('蓝牙已准备好');

    // 第三步：启动扫描，并监听结果（简单版：找第一个含 "AIZO" 的设备）
    await blueCtrl.startScan(timeout: const Duration(seconds: 10));

    // 等待扫描结果（这里用一个简单的方式监听）
    // 注意：实际项目建议做成弹窗让用户选，这里为了测试简单起见自动选第一个匹配的
    StreamSubscription? scanSub;
    scanSub = blueCtrl.discoveredDevices.listen((devices) async {
      if (devices.isEmpty) return;

      // 找名称包含 AIZO 或其他特征的设备（可根据实际情况改条件）
      final target = devices.firstWhereOrNull(
        (d) => (d.device.platformName ?? '').toUpperCase().contains('AIZO'),
      );

      if (target != null) {
        logger.d('找到目标设备：${target.device.platformName} (${target.device.remoteId.str})');

        // 停止扫描
        await blueCtrl.stopScan();
        scanSub?.cancel();

        // 尝试连接
        try {
          await blueCtrl.connectToDevice(target.device);
          logger.d('flutter_blue_plus 连接成功');

          // 关键！马上通知安卓 SDK 绑定
          final boundOk = await blueImpl.notifyBoundDevice(
            deviceName: target.device.platformName ?? 'AIZO RING',
            deviceMac: target.device.remoteId.str,
          );

          if (boundOk) {
            logger.d('notifyBoundDevice 成功');
            Get.snackbar('成功', '已连接并绑定戒指');
          } else {
            logger.w('notifyBoundDevice 返回 false');
            Get.snackbar('警告', '绑定通知失败，检查日志');
          }

          // 可选：测试获取一次电量
          final power = await blueImpl.getCurrentPowerState();
          if (power != null) {
            logger.d('测试电量：${power['electricity']}%');
          }
        } catch (e) {
          logger.e('连接或绑定失败: $e');
          Get.snackbar('失败', '连接出错：$e');
        }
      }
    });

    // 扫描超时自动清理（防止一直监听）
    Future.delayed(const Duration(seconds: 12), () {
      scanSub?.cancel();
      if (blueCtrl.isScanning.value) {
        blueCtrl.stopScan();
      }
      if (blueCtrl.discoveredDevices.isEmpty) {
        logger.w('扫描10秒未找到目标设备');
        Get.snackbar('未找到', '没有扫描到 AIZO 戒指');
      }
    });
  }

  // 辅助：断开（测试用）
  Future<void> disconnect() async {
    await blueCtrl.disconnect();
    logger.d('已断开');
  }
}
