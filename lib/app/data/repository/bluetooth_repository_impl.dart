import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo2/app/core/base/remote/base_remote_source.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/route_manager.dart';

class BluetoothRepositoryImpl extends BaseRemoteSource
    implements BluetoothRepository {
  static final BluetoothRepositoryImpl _instance =
      BluetoothRepositoryImpl._internal();
  factory BluetoothRepositoryImpl() => _instance; // ← 加上这行
  static const MethodChannel _channel = MethodChannel("com.zhangsan/aizo_ring");
  static const EventChannel _eventChannel = EventChannel(
    "com.zhangsan/aizo_ring/events",
  );
  // 连接状态（全局可监听）
  final RxBool _isConnected = false.obs;
  RxBool get isConnected => _isConnected;
  // 绑定状态（全局可监听）
  final RxBool _isBound = false.obs;
  RxBool get isBound => _isBound;

  // ==================== 电池状态（全局可监听） ====================
  final RxInt _batteryLevel = 50.obs; // 默认值
  final RxBool _isCharging = false.obs;

  RxInt get batteryLevel => _batteryLevel;
  RxBool get isCharging => _isCharging;

  BluetoothRepositoryImpl._internal() {
    // ← 改成私有构造
    _setupEventListener();
  }

  // ==================== 监听 EventChannel（连接/断开/错误） ====================
  void _setupEventListener() {
    _eventChannel.receiveBroadcastStream().listen(
      (event) {
        if (event is Map<dynamic, dynamic>) {
          final String e = event['event'] ?? '';
          final bool success = event['success'] ?? false;
          logger.d('当前监听状态================${e}');

          switch (e) {
            case 'connect':
              _isConnected.value = true;

              print('🔗 蓝牙已连接');
              Get.snackbar(
                '成功',
                '已连接 AIZO RING',
                backgroundColor: Colors.green,
              );
              break;

            case 'disconnect':
              _isConnected.value = false;
              _isBound.value = false; // ← 新增：断开就解绑

              print('❌ 蓝牙已断开 → 已重置绑定状态');
              // Get.snackbar(
              //   '失败',
              //   '❌ 蓝牙已断开 → 已重置绑定状态',
              //   backgroundColor: Colors.red,
              // );
              break;

            case 'connectError':
              _isConnected.value = false;
              _isBound.value = false; // ← 新增

              print('❌ 连接出错');
              Get.snackbar('失败', '❌ 连接出错', backgroundColor: Colors.red);
              break;

            case 'notifyBoundDeviceResult':
              print('绑定通知结果: ${success ? "成功" : "失败"}');
              _isBound.value = success;

              if (_isBound.value) {
                Get.snackbar(
                  '成功',
                  '绑定成功 AIZO RING',
                  backgroundColor: Colors.green,
                );
              } else {
                Get.snackbar(
                  '失败',
                  '❌ 绑定出错 AIZO RING',
                  backgroundColor: Colors.red,
                );
              }
              break;

            case 'deviceSetResult':
              final type = event['type'] ?? -1;
              logger.d('type=====44444=====${type}');
              print('deviceSet 结果: ${success ? "成功" : "失败"}');

              // 如果你暂时不想改原生，这里也可以不处理（上面 deviceSet 方法已经处理了）
              break;
            case 'powerState':
              if (event is Map<dynamic, dynamic>) {
                final int electricity = event['electricity'] ?? 0;
                final int workingMode = event['workingMode'] ?? 0;

                _batteryLevel.value = electricity;
                _isCharging.value = workingMode == 1;

                print(
                  '🔋 戒指电池更新: $electricity% ${workingMode == 1 ? "充电中" : "未充电"}',
                );
              }
              break;
          }
        }
      },
      onError: (error) {
        print('EventChannel 错误: $error');
        _isConnected.value = false;
        _isBound.value = false;
      },
    );
  }

  //首先判断 是否有同样操作
  //没有则 创建一个 未来 对象
  //final success = await _channel.invokeMethod进行指令下发
  //等待真正返回结果
  //根据真实结果处理状态

  @override
  Future<void> connectDevice({required String deviceMac}) async {
    await _channel.invokeMethod('connect', {'mac': deviceMac});
  }

  Future<void> notifyBoundDevice(String deviceName, String deviceMac) async {
    await _channel.invokeMethod<bool>('notifyBoundDevice', {
      'deviceName': deviceName,
      'deviceMac': deviceMac,
    });
  }

  //1 -> "恢复出厂设置"   2 -> "解绑戒指"   4 -> "重启戒指"
  @override
  Future<void> deviceSet(int type) async {
    await _channel.invokeMethod<bool>('deviceSet', {'type': type});
  }

  @override
  Future<bool> getInstantPowerState() async {
    final bool success =
        await _channel.invokeMethod<bool>('getInstantPowerState') ?? false;
    if (success) {
      print(
        '✅ 已请求实时电量，现有 PowerStateCallback 会自动更新 _batteryLevel 和 _isCharging',
      );
    }
    return true;
  }

  @override
  Future<bool> getCurrentActivityGoals() async {
    if (!_isConnected.value || !_isBound.value) {
      logger.d('连接或绑定中断，请进行连接或绑定');
      return false;
    }
    final Map<dynamic, dynamic>? goals = await _channel.invokeMethod(
      'getCurrentActivityGoals',
    );

    if (goals != null) {
      final int steps = goals['stepGlobal'] as int? ?? 8000;
      final double distance = goals['distanceGlobal'] as double? ?? 5.0; // km
      final int calories = goals['caloriesGlobal'] as int? ?? 300;

      print('🎯 活动目标: 步数 $steps | 距离 ${distance}km | 热量 ${calories}kcal');
      return true;
    }
    return false;
  }
}
