abstract class BluetoothRepository {
  // 设备初始化
  Future<bool> init();

  /// 由原生 SDK 发起连接（文档 2.1.2：connect(mac)，连接成功后在回调里 notifyBoundDevice）
  Future<bool> connectDevice({required String deviceName, required String deviceMac});

  /// 断开设备（原生调用 deviceSet(2) 解绑，SDK 会断开连接）
  Future<bool> disconnectDevice();

  // 通知 SDK 绑定戒指（一般由原生在 connect 成功回调里调用，Flutter 仅保留用于兼容）
  Future<bool> notifyBoundDevice({required String deviceName, required String deviceMac});

  Future<bool> deviceSet(int type);

  Future<Map<String, dynamic>?> getFirmwareInfo();

  Stream<Map<String, dynamic>?> get powerStateStream;

Future<Map<String, dynamic>?> getCurrentPowerState();
// Future<Map<String, dynamic>?> getUserInfo();

Future<Map<String, dynamic>?> getDeviceMeasureTime();

Future<Map<String, dynamic>?> instantMeasurement();










  // Stream<Map<String, dynamic>> get powerStream;
  // void startListenPowerState();
  // /// 停止监听（建议在页面 dispose 时调用）
  // void stopListenPowerState();
}