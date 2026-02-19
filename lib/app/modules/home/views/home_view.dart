import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
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
    return SafeArea(
      child: Stack(
        children: [
          // 如果你想让背景图可见，可以在这里加 Opacity 或其他处理
          // 但因为已经在 BaseViews 里处理了 bgImage，这里通常不需要重复放

          Column(
            children: [
              // 顶部标题 + 扫描按钮区域
              _buildHeader(),

              // 设备列表主体
              Expanded(
                child: Obx(() {
                  final devices = BluetoothUtil.scanResults;

                  if (controller.isScanning.value) {
                    return _buildScanningState();
                  }

                  if (devices.isEmpty) {
                    return _buildNoDeviceFound();
                  }

                  return _buildDeviceList(devices);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AOJ 设备连接',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                      color: Colors.black45,
                      offset: Offset(1, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Obx(() => Text(
                    controller.statusMessage.value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  )),
            ],
          ),

          // 扫描控制按钮
          Obx(() => _ScanButton(
                isScanning: controller.isScanning.value,
                onPressed: () {
                  if (controller.isScanning.value) {
                    controller.stopScan();
                  } else {
                    controller.startScan();
                  }
                },
              )),
        ],
      ),
    );
  }

  Widget _buildScanningState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          ),
          SizedBox(height: 24.h),
          Text(
            '正在搜索设备...',
            style: TextStyle(fontSize: 18.sp, color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Text(
            '请确保设备已开启并在附近',
            style: TextStyle(fontSize: 14.sp, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDeviceFound() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bluetooth_disabled_rounded,
            size: 80.w,
            color: Colors.white38,
          ),
          SizedBox(height: 24.h),
          Text(
            '暂未发现设备',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '点击上方搜索按钮开始扫描',
            style: TextStyle(fontSize: 15.sp, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList(List<ScanResult> devices) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final result = devices[index];
        final device = result.device;
        final name = device.name.isNotEmpty ? device.name : '未命名设备';

        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          color: Colors.white.withOpacity(0.92),
          child: ListTile(
            leading: Icon(
              Icons.bluetooth_audio_rounded,
              color: Colors.blueAccent,
              size: 32.w,
            ),
            title: Text(
              name,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.remoteId.str,
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 2.h),
                Text(
                  '信号强度: ${result.rssi} dBm',
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            onTap: () => controller.connectToDevice(device),
          ),
        );
      },
    );
  }
}

// 小组件：扫描/停止 按钮
class _ScanButton extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onPressed;

  const _ScanButton({
    required this.isScanning,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        isScanning ? Icons.stop_rounded : Icons.search_rounded,
        size: 20.w,
      ),
      label: Text(
        isScanning ? '停止' : '扫描',
        style: TextStyle(fontSize: 15.sp),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isScanning ? Colors.redAccent : Colors.blueAccent,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      ),
    );
  }
}