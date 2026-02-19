import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/model/aoj_constants.dart';
import 'package:flutter_demo2/app/core/utils/permission_util.dart';
import 'package:get/get.dart';


class BluetoothUtil {
  static StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  static StreamSubscription<bool>? _isScanningSubscription;
  static bool _isScanning = false;
  /// 获取扫描状态
  static bool get isScanning => _isScanning;
static final RxList<ScanResult> scanResults = <ScanResult>[].obs;    /// 获取扫描结果
  static List<ScanResult> get scanResultsList => scanResults;

  
  static BluetoothDevice? _connectedDevice;
  static bool _isInitialized = false;

    // AOJ专用连接和监听
  static BluetoothDevice? _aojDevice;
  static StreamSubscription<BluetoothConnectionState>? _aojConnectionSub;
  static StreamSubscription<List<int>>? _aojNotifySub;

  



  /// 获取已连接的设备
  static BluetoothDevice? get connectedDevice => _connectedDevice;

  /// 获取是否初始化
  static bool get isInitialized => _isInitialized;

  /// 初始化蓝牙
  static Future<bool> init() async {
    try {
      if (_isInitialized) {
        return true;
      }

      // 检查蓝牙权限
      bool bluetoothGranted = await PermissionUtil.requestBluetooth();
      if (!bluetoothGranted) {
        print('蓝牙权限未授权');
        return false;
      }

      // 检查位置权限（蓝牙扫描需要）
      bool locationGranted = await PermissionUtil.requestLocation();
      if (!locationGranted) {
        print('位置权限未授权');
        return false;
      }

      // 监听扫描状态
      _isScanningSubscription = FlutterBluePlus.isScanning.listen((scanning) {
        _isScanning = scanning;
        print('蓝牙扫描状态: ${scanning ? "正在扫描" : "停止扫描"}');
      });

      print('蓝牙初始化成功');
      _isInitialized = true;
      return true;
    } catch (e) {
      print('蓝牙初始化失败: $e');
      return false;
    }
  }

  /// 开始扫描
  static Future<void> startScan({
    Duration timeout = const Duration(seconds: 5),
    List<Guid>? withServices,
  }) async {
    try {
      // 如果已经在扫描，先停止
      if (_isScanning) {
        await stopScan();
      }

      // 清空之前的扫描结果
      scanResults.value = [];

      // 开始新的扫描
      await FlutterBluePlus.startScan(
        timeout: timeout,
        withServices: withServices ?? [],
      );

      // 监听扫描结果
      _scanResultsSubscription?.cancel();
      _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      
        
        // 过滤设备名称包含 AOJ 或 AIZO 的设备，并按 remoteId 去重
        Map<String, ScanResult> uniqueDevices = {};
        for (var result in results) {
          String deviceName = result.device.name.toUpperCase();
          if (deviceName.contains('AOJ') || deviceName.contains('AIZO')) {
            String remoteId = result.device.remoteId.str;
            if (!uniqueDevices.containsKey(remoteId)) {
              uniqueDevices[remoteId] = result;
            }
          }
        }
        
        // 检查设备列表是否有变化
        bool hasChanges = scanResults.length != uniqueDevices.length;
        if (!hasChanges) {
          for (var device in uniqueDevices.values) {
            if (!scanResults.any((result) => result.device.remoteId == device.device.remoteId)) {
              hasChanges = true;
              break;
            }
          }
        }

        // 只在设备列表发生变化时更新和打印
        if (hasChanges) {
          scanResults.assignAll(uniqueDevices.values.toList());
          for (var result in scanResults) {
            print('发现目标设备: ${result.device.name}, RSSI: ${result.rssi}, UUID: ${result.device.id}, MAC: ${result.device.remoteId.str}');
          }
          print('发现目标设备数量: ${scanResults.length}');
        }
      });
    } catch (e) {
      print('开始扫描失败: $e');
      rethrow;
    }
  }

  /// 停止扫描
  static Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
      _scanResultsSubscription?.cancel();
      _scanResultsSubscription = null;
    } catch (e) {
      print('停止扫描失败: $e');
      rethrow;
    }
  }

  /// 连接设备
  static Future<void> connect(BluetoothDevice device) async {
    try {
      print('正在连接设备: ${device.name}');
      await device.connect(
        license: License.free,  // ← 必须添加这一行（免费许可声明）
        timeout: const Duration(seconds: 10),
        autoConnect: false,
      );
      _connectedDevice = device;
      print('设备连接成功: ${device.name}');

      // 监听连接状态
      device.connectionState.listen((BluetoothConnectionState state) {
        print('设备连接状态: $state');
        if (state == BluetoothConnectionState.disconnected) {
          _connectedDevice = null;
        }
      });
    } catch (e) {
      print('连接设备失败: $e');
      rethrow;
    }
  }

  /// 断开连接
  static Future<void> disconnect() async {
    try {
      if (_connectedDevice != null) {
        await _connectedDevice!.disconnect();
        _connectedDevice = null;
        print('设备已断开连接');
      }
    } catch (e) {
      print('断开连接失败: $e');
      rethrow;
    }
  }

  /// 获取设备服务
  static Future<List<BluetoothService>> getServices(BluetoothDevice device) async {
    try {
      return await device.discoverServices();
    } catch (e) {
      print('获取设备服务失败: $e');
      rethrow;
    }
  }

  /// 写入数据
  static Future<void> writeCharacteristic(
    BluetoothCharacteristic characteristic,
    List<int> value,
  ) async {
    try {
      await characteristic.write(value);
      print('数据写入成功');
    } catch (e) {
      print('数据写入失败: $e');
      rethrow;
    }
  }

  /// 读取数据
  static Future<List<int>> readCharacteristic(
    BluetoothCharacteristic characteristic,
  ) async {
    try {
      List<int> value = await characteristic.read();
      print('数据读取成功: $value');
      return value;
    } catch (e) {
      print('数据读取失败: $e');
      rethrow;
    }
  }

  /// 监听特征值变化
  static Stream<List<int>>? notifyCharacteristic(
    BluetoothCharacteristic characteristic,
  ) {
    try {
      return characteristic.value;
    } catch (e) {
      print('监听特征值失败: $e');
      rethrow;
    }
  }

  static Future<void> aojConnectAndListenByMac(
  String macAddress, {
  required void Function(BluetoothConnectionState state) onConnectionState,
  required void Function(List<int> data) onData,
}) async {
  // 先确保已经扫描到设备
  ScanResult? targetResult;
  for (var result in scanResults) {
    if (result.device.remoteId.str.toUpperCase() == macAddress.toUpperCase()) {
      targetResult = result;
      break;
    }
  }
  if (targetResult == null) {
    throw Exception('未在扫描结果中找到MAC为 $macAddress 的设备');
  }
  await aojConnectAndListen(
    targetResult.device,
    onConnectionState: onConnectionState,
    onData: onData,
  );
}

  /// 连接 AOJ 设备并监听连接状态和数据
  static Future<void> aojConnectAndListen(
    BluetoothDevice device, {
    required void Function(BluetoothConnectionState state) onConnectionState,
    required void Function(List<int> data) onData,
  }) async {
    _aojDevice = device;

    // 连接设备
    await device.connect(
      license: License.free,  // ← 必须添加这一行（免费许可声明）
      timeout: const Duration(seconds: 10), autoConnect: false);

    // 监听连接状态
    _aojConnectionSub?.cancel();
    _aojConnectionSub = device.connectionState.listen((state) {
      print('AOJ设备连接状态: $state');
      onConnectionState(state);
    });

    // 发现服务并监听 notify 特征值
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      if (service.uuid == AOJConstants.serviceUUID) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid == AOJConstants.notifyUUID) {
            // 开启通知
            await characteristic.setNotifyValue(true);
            _aojNotifySub?.cancel();
            _aojNotifySub = characteristic.value.listen((data) {
              print('AOJ收到数据: $data');
              onData(data);
            });
            print('已监听AOJ特征值: ${characteristic.uuid}');
            return;
          }
        }
      }
    }
    throw Exception('未找到AOJ的Notify特征值');
  }

  /// 断开AOJ连接和释放资源
  static Future<void> aojDisconnect() async {
    _aojNotifySub?.cancel();
    _aojConnectionSub?.cancel();
    if (_aojDevice != null) {
      await _aojDevice!.disconnect();
      _aojDevice = null;
    }
  }
  

  /// 释放资源
  static void dispose() {
    _scanResultsSubscription?.cancel();
    _isScanningSubscription?.cancel();
    disconnect();
  }
}