import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/base/controller/bluetooth_controller.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository_impl.dart'; // 如果你有 repository 层
import 'package:flutter_demo2/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeView extends BaseViews<HomeController> {
  HomeView({super.key})
    : super(
        bgImage: PageBackground(
          imagePath: Assets.images.backgronud.path, // 建议修正拼写 → background
          top: 0.0,
          left: 0.0,
          width: 375.w,
          height: 812.h + MediaQuery.of(Get.context!).padding.top,
          fit: BoxFit.fitHeight,
        ),
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      );

  @override
  Widget? appBar(BuildContext context) => null;
  @override
  Widget body(BuildContext context) {
    final blueController = Get.put(BluetoothController()); // 测试用，put 进去

    return SafeArea(
      child: Column(
        children: [
          // 顶部区域
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '蓝牙测试',
                  style: TextStyle(fontSize: 24.sp, color: Colors.white),
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      if (blueController.isScanning.value) {
                        blueController.stopScan();
                      } else {
                        blueController.startScan();
                      }
                      // controller.connect();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueController.isScanning.value
                          ? Colors.red
                          : Colors.blue,
                    ),
                    child: Text(
                      blueController.isScanning.value ? '停止' : '扫描',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 状态提示
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                blueController.isScanning.value
                    ? '正在扫描...'
                    : blueController.discoveredDevices.isEmpty
                    ? '暂无设备'
                    : '发现 ${blueController.discoveredDevices.length} 个设备',
                style: TextStyle(fontSize: 16.sp, color: Colors.white70),
              ),
            ),
          ),

          // 设备列表
          Expanded(
            child: Obx(() {
              if (blueController.discoveredDevices.isEmpty) {
                return const Center(
                  child: Text(
                    '点击扫描查找设备',
                    style: TextStyle(color: Colors.white60, fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(12.w),
                itemCount: blueController.discoveredDevices.length,
                itemBuilder: (ctx, i) {
                  final result = blueController.discoveredDevices[i];
                  final device = result.device;
                  final name = device.name.isEmpty ? '未知设备' : device.name;

                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: ListTile(
                      title: Text(name),
                      subtitle: Text(
                        '${device.remoteId.str}   RSSI: ${result.rssi}',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // 测试 AOJ 连接（假设是 AOJ 设备）
                          if (name.toUpperCase().contains('AOJ') ||
                              name.toUpperCase().contains('AIZO')) {
                                print('aojb连接');
                            blueController.connectAojByMac(device.remoteId.str);
                          } else {
                            blueController.connectToDevice(device);
                          }
                        },
                        child: const Text('连接'),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // 底部连接状态 + 断开按钮
          Obx(
            () {
              final connected = blueController.isAojConnected.value;
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      connected
                          ? 'AOJ 已连接'
                          : '未连接',
                      style: TextStyle(
                        color: connected ? Colors.green : Colors.red,
                        fontSize: 16.sp,
                      ),
                    ),
                    if (connected)
                      ElevatedButton(
                        onPressed: () async {
                          await blueController.disconnectAoj();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('断开设备', style: TextStyle(fontSize: 14.sp)),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
