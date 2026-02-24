abstract class BluetoothRepository {
  /// 由原生 SDK 发起连接（文档 2.1.2：connect(mac)，连接成功后在回调里 notifyBoundDevice）
  Future<void> connectDevice({required String deviceMac});

  Future<void> notifyBoundDevice(String deviceName, String deviceMac);

  Future<void> deviceSet(int type);

  Future<bool> getInstantPowerState();

  Future<bool> getCurrentActivityGoals();

  // Stream<Map<String, dynamic>> get powerStream;
  // void startListenPowerState();
  // /// 停止监听（建议在页面 dispose 时调用）
  // void stopListenPowerState();
}
