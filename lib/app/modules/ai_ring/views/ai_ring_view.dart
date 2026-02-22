import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/modules/ai_ring/widget/blood_oxygen_paint.dart';
import 'package:flutter_demo2/app/modules/ai_ring/widget/blood_pressure_paint.dart';
import 'package:flutter_demo2/app/modules/ai_ring/widget/temperature_paint.dart';
import 'package:flutter_demo2/app/modules/ai_ring/widget/weight_paint.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../controllers/ai_ring_controller.dart';

class AiRingView extends BaseViews<AiRingController> {
  AiRingView({super.key}) : super(bgColor: Color(0xfffafafa));
  @override
  Widget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 50.h, left: 25.w, right: 25.w),
      child: SingleChildScrollView(
        child: GridView(
          shrinkWrap: true, // ← 必须加！解决 unbounded height
          physics: const NeverScrollableScrollPhysics(), // 禁止 GridView 自己滚动

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 1.0,
          ),
          children: <Widget>[
            _bloodOxygenCard(),
            _bloodPressureCard(),
            // TemperatureCanvas(),
            _temperatureCard(),
            _bloodSugarCard(),
            _weightCard(),

            // Image.asset(Assets.images.temperature.path),
            // TemperatureCanvas(),
          ],
        ),
      ),
    );
  }
}

Widget cardText(String label) {
  return Text(
    '${label}',
    style: TextStyle(
      color: Color(0xff333333),
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
    ),
  );
}

Widget imageAsset(String path) {
  return Image.asset(path, width: 16.w, height: 16.h);
}

Widget _buildCard({
  required String title,
  required IconData icon,
  required Widget child,
  String? imagePath,
}) {
  return Container(
    padding: EdgeInsets.all(16.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(icon, size: 22.w, color: Colors.grey[600]),
          ],
        ),
        // Expanded(child: child),
        Expanded(
          child: Stack(
            children: [
              if (imagePath != null)
                Positioned.fill(
                  child: Center(child: Image.asset(imagePath, width: 85.w, height: 85.h),),
                ),

              Positioned(child: Center(child: child,)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _bloodOxygenCard() {
  return _buildCard(
    title: 'Blood Oxygen',
    icon: Icons.bloodtype_outlined,
    child: BloodOxygenCanvas(),
  );
}

Widget _bloodPressureCard() {
  return _buildCard(
    title: 'Blood Pressure',
    icon: Icons.bloodtype_outlined,
    child: BloodPressureCanvas(label: '中度'),
  );
}

Widget _temperatureCard() {
  return _buildCard(
    title: 'Temperature',
    icon: Icons.bloodtype_outlined,
    child: TemperatureCanvas(),
  );
}

Widget _bloodSugarCard() {
  return _buildCard(
    title: 'Blood sugar',
    icon: Icons.bloodtype_outlined,
    imagePath: Assets.images.bloodSugar.path,
    child: Column(
      children: [
        Gap(25.h),
        Text('43'),
       Text('mg/dL')
      ],
    ),
  );
}
Widget _weightCard() {
  return _buildCard(
    title: 'Weight',
    icon: Icons.bloodtype_outlined,
    child: WeightConvas(currentValue: 65,),
  );
}