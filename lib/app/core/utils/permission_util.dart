import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  /// 请求蓝牙扫描、连接 + 定位权限
Future<bool> requestBlePermissions() async {
  final statuses = await [
    Permission.bluetoothScan,     // 扫描设备（Android 12+ 必须）
    Permission.bluetoothConnect,  // 连接设备（Android 12+ 必须）
    Permission.locationWhenInUse, // Android 扫描 BLE 必须要有位置权限（用 WhenInUse 即可）
    // Permission.bluetooth,      // 老版本 Android/iOS 通用，可选加
  ].request();

  // 检查是否全部授权
  final granted = statuses[Permission.bluetoothScan]!.isGranted &&
                  statuses[Permission.bluetoothConnect]!.isGranted &&
                  statuses[Permission.locationWhenInUse]!.isGranted;

  // 如果用户永久拒绝，引导去设置页打开
  if (statuses.values.any((s) => s.isPermanentlyDenied)) {
    await openAppSettings();
  }

  return granted;
}
}