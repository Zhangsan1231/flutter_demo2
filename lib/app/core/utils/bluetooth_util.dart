import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/utils/permission_util.dart';
import 'dart:async';

class BluetoothUtil {
  // 保存本次扫描到的结果（包含 rssi）
  final List<ScanResult> _foundScanResults = [];

  // 对外暴露的 Stream（推荐给 GetX / StreamBuilder 使用）
  final _scanResultsController = StreamController<List<ScanResult>>.broadcast();
  Stream<List<ScanResult>> get scanResultsStream => _scanResultsController.stream;

  // ====================== 权限 ======================
  Future<void> requestBlePermissions() async {
    bool hasPermission = await PermissionUtil().requestBlePermissions();
    if (hasPermission) {
      print('✅ 权限已获取');
      startScan();                    // 自动开始扫描
    } else {
      print('❌ 权限被拒绝');
    }
  }

  // ====================== 开始扫描 ======================
  void startScan() async {
    _foundScanResults.clear();                    // 清空旧数据
    _scanResultsController.add([]);               // 清空 UI

    // 1. 检查蓝牙是否打开
    final adapterState = await FlutterBluePlus.adapterState.first;
    if (adapterState != BluetoothAdapterState.on) {
      print('蓝牙未开启，正在请求打开...');
      await FlutterBluePlus.turnOn();
      return;
    }

    // 2. 开始扫描（只搜 AIZO RING）
    await FlutterBluePlus.startScan(
      withNames: ['AIZO RING'],
      timeout: const Duration(seconds: 15),
    );

    // 3. 实时监听结果（去重 + 保存 RSSI）
    FlutterBluePlus.onScanResults.listen((List<ScanResult> results) {
      for (ScanResult r in results) {
        // 去重（按设备 ID）
        if (!_foundScanResults.any((s) => s.device.remoteId == r.device.remoteId)) {
          _foundScanResults.add(r);

          print('✅ 找到 AIZO RING → '
              'ID: ${r.device.remoteId} '
              '名称: ${r.device.platformName} '
              'RSSI: ${r.rssi} dBm');

          // 实时推送给 UI
          _scanResultsController.add(List.from(_foundScanResults));
        }
      }
    });
  }

  // ====================== 停止扫描 ======================
  void stopScan() {
    FlutterBluePlus.stopScan();
    print('扫描已停止');
  }

  // ====================== 一次性扫描并返回结果（可选使用） ======================
  Future<List<ScanResult>> scanAndGetDevices() async {
    _foundScanResults.clear();

    final completer = Completer<List<ScanResult>>();

    // 检查并打开蓝牙
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      await FlutterBluePlus.turnOn();
    }

    final subscription = FlutterBluePlus.onScanResults.listen((results) {
      for (var r in results) {
        if (!_foundScanResults.any((s) => s.device.remoteId == r.device.remoteId)) {
          _foundScanResults.add(r);
        }
      }
    });

    await FlutterBluePlus.startScan(
      withNames: ['AIZO RING'],
      timeout: const Duration(seconds: 15),
    );

    // 15秒后返回结果
    Future.delayed(const Duration(seconds: 15, milliseconds: 300), () {
      subscription.cancel();
      FlutterBluePlus.stopScan();
      completer.complete(List.from(_foundScanResults));
      _scanResultsController.add(List.from(_foundScanResults));
    });

    return completer.future;
  }


// ====================== 【新增】连接设备 ======================
  /// 连接指定设备（传入 ScanResult.device）
  Future<bool> connectDevice(BluetoothDevice device) async {
    try {
      print('正在连接 ${device.platformName} (${device.remoteId})...');

      await device.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false, license: License.free,        // 手动连接
      );

      // 监听连接状态
      device.connectionState.listen((BluetoothConnectionState state) {
        print('连接状态变化: $state');
        if (state == BluetoothConnectionState.connected) {
          print('🎉 连接成功！');
        } else if (state == BluetoothConnectionState.disconnected) {
          print('❌ 已断开连接');
        }
      });

      // 发现服务（必须等 connected 后再调用）
      await Future.delayed(const Duration(milliseconds: 800));
      List<BluetoothService> services = await device.discoverServices();

      print('发现 ${services.length} 个服务：');
      for (var service in services) {
        print('  Service UUID: ${service.uuid}');
        for (var characteristic in service.characteristics) {
          print('    Characteristic: ${characteristic.uuid}');
        }
      }

      return true;
    } catch (e) {
      print('❌ 连接失败: $e');
      return false;
    }
  }
  // ====================== 释放资源（页面关闭时调用） ======================
  void dispose() {
    _scanResultsController.close();
    print('BluetoothUtil 已释放');
  }
}