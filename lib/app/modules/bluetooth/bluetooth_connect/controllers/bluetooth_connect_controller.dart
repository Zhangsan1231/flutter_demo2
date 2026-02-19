import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart';
import 'package:get/get.dart';

class BluetoothConnectController extends BaseController {
  final searchBluetooth = false.obs;
  final foundDevices = <ScanResult>[].obs;  // 推荐自己维护一个 RxList

  // RxBool searchBluetooth = true.obs;
  // final blueUtil = BluetoothUtil();

@override
void onInit() {
  super.onInit();

  // 监听扫描状态（loading 动画用）
  FlutterBluePlus.isScanning.listen((bool isScanningNow) {
    searchBluetooth.value = isScanningNow;
    
    if (!isScanningNow) {
      logger.d('扫描结束，目前发现 ${foundDevices.length} 个设备');
    }
  });

  // 监听扫描结果（实时更新设备列表）
FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
  final filtered = results.where((r) {
    // 过滤逻辑保持不变
    final name = (r.device.platformName ?? r.advertisementData.advName ?? '').toUpperCase();
    return name.contains('AOJ') || name.contains('AIZO');
  }).toList();

  foundDevices.assignAll(filtered);

  logger.d('实时更新设备列表 → ${foundDevices.length} 个');

  // 打印每个过滤后的设备详细信息（重点看名称来源）
  if (foundDevices.isNotEmpty) {
    logger.d('─────────────── 发现的设备详情 ───────────────');
    for (var r in foundDevices) {
      final platformName = r.device.platformName;
      final advName      = r.advertisementData.advName;
      final localName    = r.advertisementData.localName;

      final displayName = platformName?.isNotEmpty == true
          ? platformName
          : (advName?.isNotEmpty == true ? advName : (localName ?? '无名称'));

      logger.d('设备: $displayName');
      logger.d('  • platformName : ${platformName ?? "空"}');
      logger.d('  • advName      : ${advName ?? "空"}');
      logger.d('  • localName    : ${localName ?? "空"}');
      logger.d('  • MAC / remoteId: ${r.device.remoteId.str}');
      logger.d('  • RSSI         : ${r.rssi} dBm');
      logger.d('  • 原始 device.name (不推荐): ${r.device.name ?? "空"}');
      logger.d('──────────────────────────────');
    }
  } else {
    logger.d('本次更新无符合条件的 AOJ/AIZO 设备');
  }
});
}
  Future<void> startScan() async {
    logger.d('开始扫描设备');

    if (searchBluetooth.value) {
      logger.d('已在扫描中，忽略重复调用');
      return;
    }

    try {
      // 可选：先清空旧数据
      foundDevices.clear();

      await BluetoothUtil.startScan(
        timeout: const Duration(seconds: 10),  // 自动停止时间
      );

      // 这里不需要 await 任何东西，stream 会自动处理
      // 扫描过程中 UI 会实时更新，结束后 searchBluetooth → false

    } catch (e) {
      logger.e('扫描启动失败: $e');
      searchBluetooth.value = false;
    }
  }

  // 可选：手动停止
  Future<void> stopScan() async {
    await BluetoothUtil.stopScan();
  }
}