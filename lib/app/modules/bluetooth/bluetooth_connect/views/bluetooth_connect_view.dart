import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bluetooth_connect_controller.dart';

class BluetoothConnectView extends GetView<BluetoothConnectController> {
  const BluetoothConnectView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BluetoothConnectView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BluetoothConnectView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
