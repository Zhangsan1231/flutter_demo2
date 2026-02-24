import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/utils/bluetooth_util.dart';
import 'package:flutter_demo2/app/data/repository/bluetooth_repository_impl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/bluetooth_controller.dart';

class BluetoothView extends BaseViews<BluetoothController> {
  @override
  Widget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
                    Gap(50.h),

          Obx(() => Text(BluetoothRepositoryImpl().isConnected.value ? '已连接' : '未连接')),

           Obx(() => Text(BluetoothRepositoryImpl().isBound.value ? '已绑定' : '未绑定')),
                      Obx(() => Text(BluetoothRepositoryImpl().isConnected.value 
                        
                        
                        ?'电量:${BluetoothRepositoryImpl().batteryLevel.value}'
                        :'未连接'
                        )),
           Obx(() => Text(BluetoothRepositoryImpl().isCharging.value ? "充电中" : "未充电")),

           
          Gap(50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
            onTap: () {
              controller.startScan();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(color: Colors.amber),
              child: Text('搜索蓝牙'),
            ),
          ),

          Gap(20.h),
          // InkWell(
          //   onTap: () {
          //     // controller.notifyBoundDevice();
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          //     decoration: BoxDecoration(color: Colors.amber),
          //     child: Text('绑定'),
          //   ),
          // ),
          // Gap(20.h),
          InkWell(
            onTap: () {
              controller.deviceBound();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(color: Colors.amber),
              child: Text('解绑'),
            ),
          ),
          Gap(20.w),
             InkWell(
            onTap: () {
              BluetoothRepositoryImpl().getInstantPowerState();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(color: Colors.amber),
              child: Text('获取电池状态'),
            ),
          ),
          
            ],
          ),
          Gap(20.h),
           InkWell(
            onTap: () {
              BluetoothRepositoryImpl().getCurrentActivityGoals();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(color: Colors.amber),
              child: Text('获取当前活动目标'),
            ),
          ),
          
          Obx(() {
            if (controller.isScanning.value) {
              return Text('蓝牙正在搜索中');
            } else {
              return Text('请进行蓝牙搜索');
            }
          }),
          Gap(50.h),
          Expanded(
  child: Obx(
    () => ListView.builder(
      itemCount: controller.scanResults.length,
      itemBuilder: (context, index) {
        final scanResult = controller.scanResults[index];   // 更清晰
        final device = scanResult.device;

        return ListTile(
          title: Text(
            device.platformName.isNotEmpty
                ? device.platformName
                : '未知设备',
          ),
          subtitle: Text('ID: ${device.remoteId}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,   // 关键！防止占满整行
            children: [
              // ==================== 1. 连接按钮（保持原来样式） ====================
              InkWell(
                onTap: () {
                  controller.connectToDevice(scanResult);   // 你原来的方法
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.h),
                    color: Colors.amber,
                  ),
                  child: const Text('连接', style: TextStyle(color: Colors.white)),
                ),
              ),

              SizedBox(width: 8.w),   // 两个按钮之间的间距

              // ==================== 2. 新增：绑定按钮 ====================
              InkWell(
                onTap: () {
                  final deviceName = device.platformName.isNotEmpty
                      ? device.platformName
                      : "我的戒指";                    // 默认名称，可改

                  final deviceMac = device.remoteId.toString();   // Android 上通常就是 MAC

                  controller.notifyBoundDevice(scanResult);  // ← 需要你在 Controller 里实现
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.h),
                    color: Colors.green,        // 绑定按钮用绿色更明显
                  ),
                  child: const Text('绑定', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    ),
  ),
),
        
        ],
      ),
    );
  }
}
