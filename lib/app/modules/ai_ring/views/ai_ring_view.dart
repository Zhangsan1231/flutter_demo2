import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
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
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 1.05,
        children: [_buildBloodOxygenCard()],
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
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),
            Icon(icon, size: 22.w, color: Colors.grey[600]),
          ],
        ),
        Expanded(child: child),
      ],
    ),
  );
}

Widget _buildBloodOxygenCard() {
  return _buildCard(
    title: 'Blood oxygen',
    icon: Icons.water_drop,
    child: SfRadialGauge(
      // 1. 创建径向仪表盘
      axes: <RadialAxis>[
        // 2. 定义一个或多个轴（通常一个）
        RadialAxis(
          minimum: 70, // 3. 最小值（血氧最低70）
          maximum: 100, // 4. 最大值（血氧最高100）
          showLabels: false, // 5. 不显示刻度文字（更干净）
          showTicks: false, // 6. 不显示刻度线
          radiusFactor: 0.85, // 7. 圆环占整个控件的85%大小
          // 背景圆环样式（灰色底环）
          axisLineStyle: const AxisLineStyle(
            thickness: 0.2, // 圆环粗细
            cornerStyle: CornerStyle.bothCurve, // 两端圆角
            color: Color(0xFFE0E0E0), // 背景颜色（浅灰）
          ),

          // 指针（真正显示进度的部分）
          pointers: <GaugePointer>[
            RangePointer(
              // 最常用的指针类型
              value: 95, // 当前血氧值
              width: 0.2, // 指针宽度
              color: Colors.red, // 默认颜色（会被渐变覆盖）
              cornerStyle: CornerStyle.bothCurve,

              // 渐变颜色（从绿→橙→红）
              gradient: const SweepGradient(
                colors: [Colors.green, Colors.orange, Colors.red],
                stops: [0.0, 0.6, 1.0], // 颜色分布位置
              ),
            ),
          ],

          // 中心注释（大数字）
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 90, // 90度 = 正下方（中心）
              positionFactor: 0.0, // 0.0 = 完全居中
              widget: Text(
                '95%',
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
