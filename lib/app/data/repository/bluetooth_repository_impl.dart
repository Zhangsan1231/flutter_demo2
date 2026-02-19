import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo2/app/core/base/remote/base_remote_source.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository.dart';

class BluetoothRepositoryImpl extends BaseRemoteSource
    implements BluetoothRepository {
  static const MethodChannel _channel = MethodChannel("com.zhangsan/aizo_ring");


  @override
  Future<bool> init() async {
    try {
      final bool success = await _channel.invokeMethod('init');
      print('Flutter 调用初始化结果: $success');
      return success;
    } on PlatformException catch (e) {
      print('Flutter 初始化调用失败: ${e.message}');
      return false;
    } catch (e) {
      print('Flutter 初始化异常: $e');
      return false;
    }
  }

  @override
  Future<bool> notifyBoundDevice({
    required String deviceName,
    required String deviceMac,
  }) async {
    try {
      // deviceName 不能为空，SDK 文档要求必填
      final String name = deviceName.isNotEmpty
          ? deviceName
          : "AIZO Ring"; // 给个默认值防止空

      final bool success = await _channel.invokeMethod('notifyBoundDevice', {
        'deviceName': name,
        'deviceMac': deviceMac,
      });

      print('通知绑定戒指结果: $success');
      return success;
    } on PlatformException catch (e) {
      print('通知绑定戒指调用失败: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('通知绑定戒指异常: $e');
      return false;
    }
  }

  /// 戒指设置操作（解绑 / 恢复出厂 / 重启）
  /// [type] 必须是 1, 2, 4 中的一个
  ///   1 → 恢复出厂设置
  ///   2 → 解绑戒指
  ///   4 → 重启戒指（约25秒）
  @override
  Future<bool> deviceSet(int type) async {
    if (![1, 2, 4].contains(type)) {
      print('无效的 type 值: $type，必须是 1、2 或 4');
      return false;
    }

    try {
      final bool success = await _channel.invokeMethod('deviceSet', {
        'type': type,
      });

      print('戒指设置操作 ($type) 结果: $success');
      return success;
    } on PlatformException catch (e) {
      print('戒指设置调用失败: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('戒指设置异常: $e');
      return false;
    }
  }

  /// 获取戒指硬件信息（固件参数）
  /// 需要设备已连接，否则返回 null
  @override
  Future<Map<String, dynamic>?> getFirmwareInfo() async {
    try {
      final dynamic result = await _channel.invokeMethod('getFirmwareInfo');

      if (result == null) {
        print('获取硬件信息失败：设备未连接或 SDK 返回 null');
        return null;
      }

      // result 应该是 Map<String, dynamic>，包含所有字段
      print('硬件信息获取成功: $result');
      return result as Map<String, dynamic>;
    } on PlatformException catch (e) {
      print('获取硬件信息调用失败: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('获取硬件信息异常: $e');
      return null;
    }
  }


  /// 监听戒指电池状态变化
/// 返回 Stream<Map<String, dynamic>?>，每次电量变化推送一次
Stream<Map<String, dynamic>?> get powerStateStream {
  const eventChannel = EventChannel('com.zhangsan/aizo_ring_power');
  return eventChannel.receiveBroadcastStream().map((dynamic event) {
    if (event == null) return null;
    return event as Map<String, dynamic>;
  });
}

  @override
  // TODO: implement powerStream
  Stream<Map<String, dynamic>> get powerStream => throw UnimplementedError();

/// 主动获取一次当前电池状态
/// 返回 Map 包含 electricity (电量百分比)、workingMode (充电状态)等字段
/// 如果设备未连接、调用失败或超时，返回 null
@override
Future<Map<String, dynamic>?> getCurrentPowerState() async {
  try {
    final dynamic result = await _channel.invokeMethod('getCurrentPowerState');

    if (result == null) {
      print('获取当前电池状态失败：设备未连接或 SDK 返回 null');
      return null;
    }

    print('当前电池状态获取成功: $result');
    return result as Map<String, dynamic>;
  } on PlatformException catch (e) {
    print('获取当前电池状态调用失败: ${e.code} - ${e.message}');
    return null;
  } catch (e) {
    print('获取当前电池状态异常: $e');
    return null;
  }
}
}
