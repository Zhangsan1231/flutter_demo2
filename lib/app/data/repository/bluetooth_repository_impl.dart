import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo2/app/core/base/remote/base_remote_source.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository.dart';

class BluetoothRepositoryImpl  extends BaseRemoteSource implements BluetoothRepository{
  
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
  
  
  
}
