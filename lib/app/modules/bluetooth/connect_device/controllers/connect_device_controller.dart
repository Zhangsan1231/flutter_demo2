import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/base/controller/bluetooth_controller.dart';
import 'package:get/get.dart';

class ConnectDeviceController extends BaseController {
  /// 第一步：连接设备成功（进入页面即视为已选设备，先展示勾）
  final connectSuccess = true.obs;
  /// 第二步：绑定中
  final isBinding = true.obs;
  /// 第二步：绑定成功
  final bindSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _doBind();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 根据路由参数执行绑定（由 BluetoothConnectView 传 deviceMac、deviceName）
  Future<void> _doBind() async {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      isBinding.value = false;
      Get.snackbar('提示', '缺少设备参数');
      return;
    }
    final deviceMac = args['deviceMac'] as String?;
    final deviceName = args['deviceName'] as String? ?? 'AIZO RING';
    if (deviceMac == null || deviceMac.isEmpty) {
      isBinding.value = false;
      Get.snackbar('提示', '设备 MAC 为空');
      return;
    }
    try {
      final blueCtrl = Get.isRegistered<BluetoothController>()
          ? Get.find<BluetoothController>()
          : Get.put(BluetoothController());
      bool timedOut = false;
      // 本页已有转圈，不再弹出 Get.dialog；加超时避免一直转圈
      await blueCtrl.connectAojByMac(
        deviceMac,
        deviceName: deviceName,
        showLoading: false,
      ).timeout(
        const Duration(seconds: 28),
        onTimeout: () {
          timedOut = true;
          isBinding.value = false;
          Get.snackbar('提示', '绑定超时，请重试');
        },
      );
      if (!timedOut) {
        bindSuccess.value = true;
      }
      isBinding.value = false;
    } catch (e) {
      logger.e('绑定失败: $e');
      isBinding.value = false;
      Get.snackbar('绑定失败', e.toString());
    }
  }
}
