import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controllers/bluetooth_setting_controller.dart';

class BluetoothSettingView extends BaseViews<BluetoothSettingController> {
  BluetoothSettingView({super.key}) : super(bgColor: Color(0xfff5f5f5));

  @override
  Widget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.chevron_left, size: 28.sp, color: Color(0xff333333)),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Bluetooth Function',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Color(0xff333333),
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: Icon(
            Icons.bluetooth,
            color: Color(0xff1e6dff),
            size: 28.sp,
          ),
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Gap(8.h),
          _ringHeader(),
          Gap(20.h),
          _card(
            child: Obx(() => _row(
                  'Bluetooth',
                  trailing: Switch(
                    value: controller.bluetoothOn.value,
                    onChanged: controller.toggleBluetooth,
                    activeColor: Color(0xff34C759),
                  ),
                )),
          ),
          Gap(12.h),
          _card(
            title: 'Equipment status',
            child: Obx(() => Column(
                  children: [
                    _statusRow('AIZO connection status', controller.connectionStatus.value),
                    _statusRow('AIZO battery status', controller.batteryStatus.value),
                    _statusRow('AIZO battery level', '${controller.batteryLevel.value}%'),
                    _statusRow('Measurement results', controller.measurementResults.value),
                    _statusRow('Current measurement status', controller.currentMeasurementStatus.value),
                  ],
                )),
          ),
          Gap(12.h),
          _card(
            title: 'Measurement Control',
            child: Column(
              children: [
                _tapRow('Measure Heart Rate', onTap: controller.measureHeartRate),
                _tapRow('Measure Blood Oxygen', onTap: controller.measureBloodOxygen),
                _tapRow('Measure Temperature', onTap: controller.measureTemperature),
              ],
            ),
          ),
          Gap(12.h),
          _card(
            title: 'Measurement Interval',
            child: Obx(() => Column(
                  children: [
                    _tapRow('Get Current Interval'),
                    _intervalRow('Set 10 Minutes Interval', 10),
                    _intervalRow('Set 20 Minutes Interval', 20),
                    _intervalRow('Set 30 Minutes Interval', 30),
                  ],
                )),
          ),
          Gap(12.h),
          _card(
            title: 'Data Retrieval',
            child: Column(
              children: [
                _tapRow('Get Health Data', onTap: controller.getHealthData),
                _tapRow('Get Sleep Data', onTap: controller.getSleepData),
                _tapRow('Get Hardware Info', onTap: controller.getHardwareInfo),
              ],
            ),
          ),
          Gap(24.h),
        ],
      ),
    );
  }

  Widget _ringHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffe8f4ff), Color(0xfff5f9ff)],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Image.asset(
          Assets.images.aiRing.path,
          width: 140.w,
          height: 100.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _card({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff999999),
              ),
            ),
            Gap(12.h),
          ],
          child,
        ],
      ),
    );
  }

  Widget _row(String label, {required Widget trailing}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xff333333),
          ),
        ),
        Spacer(),
        trailing,
      ],
    );
  }

  Widget _statusRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xff666666),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xff333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tapRow(String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _intervalRow(String label, int minutes) {
    return Obx(() {
      final selected = controller.selectedIntervalMinutes.value == minutes;
      return InkWell(
        onTap: () => controller.setInterval(minutes),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff333333),
                ),
              ),
              Spacer(),
              if (selected)
                Icon(
                  Icons.check,
                  size: 22.sp,
                  color: Color(0xff1e6dff),
                ),
            ],
          ),
        ),
      );
    });
  }
}
