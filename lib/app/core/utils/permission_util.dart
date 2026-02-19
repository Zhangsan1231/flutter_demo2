import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  /// 请求蓝牙相关权限（Android 12+ 优先使用新权限，iOS 依赖 Info.plist）
  static Future<bool> requestBluetooth() async {
    if (Platform.isIOS) {
      // iOS 蓝牙权限已在 Info.plist 中声明，无需额外请求
      // 但可以检查蓝牙是否开启
      final state = await FlutterBluePlus.adapterState.first;
      if (state != BluetoothAdapterState.on) {
        print('蓝牙1111111111');
        await FlutterBluePlus.turnOn(); // 弹出系统开启蓝牙对话框
        final newState = await FlutterBluePlus.adapterState.first;
        if (newState != BluetoothAdapterState.on) {
          _showSnackBar('请开启蓝牙');
          return false;
        }
      }
      return true;
    }

    // Android
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      // 检查是否有永久拒绝的权限
      if (statuses.values.any((s) => s.isPermanentlyDenied)) {
        _showOpenSettingsSnackBar('蓝牙权限被永久拒绝，请在设置中开启');
        final result = await openAppSettings();
        if (!result) {
          return false;
        }
        // 重新请求一次
        final newStatuses = await [
          Permission.bluetooth,
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ].request();
        allGranted = newStatuses.values.every((s) => s.isGranted);
      }

      if (!allGranted) {
        _showSnackBar('蓝牙权限未授权，无法使用蓝牙功能');
        return false;
      }
    }

    return true;
  }

  /// 请求位置权限（Android 11及以下必须，12+ 如果未声明 neverForLocation 也需要）
  static Future<bool> requestLocation() async {
    if (Platform.isIOS) {
      // iOS 不需要位置权限来扫描 BLE
      return true;
    }

    // Android
    // 优先尝试请求 locationWhenInUse（最常用）
    var status = await Permission.locationWhenInUse.request();

    if (status.isDenied) {
      // 如果被拒绝，再试一次（用户可能误操作）
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isPermanentlyDenied) {
      _showOpenSettingsSnackBar('位置权限被永久拒绝，蓝牙扫描可能受限，请在设置中开启');
      final opened = await openAppSettings();
      if (!opened) return false;

      // 重新检查
      status = await Permission.locationWhenInUse.status;
    }

    if (!status.isGranted) {
      _showSnackBar('位置权限未授权，部分设备可能无法扫描蓝牙设备');
      // 注意：即使位置权限拒绝，如果 Manifest 中声明了 neverForLocation，Android 12+ 仍可扫描
      // 但为了最大兼容，这里还是提示用户
    }

    // 可选：检查定位服务是否开启（强烈推荐）
    // 需要 geolocator 包支持，或者用 FlutterBluePlus 间接判断
    // 这里简单跳过，但生产环境建议加上

    return true;
  }

  /// 请求蓝牙 + 位置权限（适合 init() 时一次性调用）
  static Future<bool> requestAllBlePermissions() async {
    final bluetoothOk = await requestBluetooth();
    if (!bluetoothOk) return false;

    final locationOk = await requestLocation();
    return locationOk;
  }

  /// 辅助：显示普通提示
  static void _showSnackBar(String message) {
    Get.snackbar(
      '提示',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }

  /// 辅助：显示需要去设置的提示
  static void _showOpenSettingsSnackBar(String message) {
    Get.snackbar(
      '权限缺失',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 6),
      mainButton: TextButton(
        onPressed: () async {
          await openAppSettings();
          Get.back(); // 关闭 snackbar
        },
        child: const Text('去设置', style: TextStyle(color: Colors.blue)),
      ),
      backgroundColor: Colors.red[900],
      colorText: Colors.white,
    );
  }
}