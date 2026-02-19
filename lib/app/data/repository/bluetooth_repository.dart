abstract class BluetoothRepository {
  //设备初始化 
  Future<bool> init();

  // 通知 SDK 绑定戒指
  Future<bool> notifyBoundDevice({required String deviceName, required String deviceMac});

  Future<bool> deviceSet(int type);

  Future<Map<String, dynamic>?> getFirmwareInfo();

  Stream<Map<String, dynamic>?> get powerStateStream;

Future<Map<String, dynamic>?> getCurrentPowerState();
  // Stream<Map<String, dynamic>> get powerStream;
  // void startListenPowerState();
  // /// 停止监听（建议在页面 dispose 时调用）
  // void stopListenPowerState();
}