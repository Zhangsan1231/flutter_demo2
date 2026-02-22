import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SleepPaint extends CustomPainter {
  final double sleepHours;   // ← 新增：外界传入的睡眠小时数（例如 7.5）

  SleepPaint({this.sleepHours = 0.0});
  @override
  void paint(Canvas canvas, Size size) {
    
    // TODO: implement paint // 计算画布中心点和圆形半径（当前尺寸下 radius=40 比较合适）
    final center = Offset(size.width / 2, (size.height / 2));
    final radius =50.0;

    final onePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.withOpacity(0.25)
      ..strokeWidth = 8.0;
      canvas.drawCircle(center, radius, onePaint);
       final twoPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Color(0x141B6BFF)
      ..strokeWidth = 8.0;
      canvas.drawCircle(center, radius-10, twoPaint);


      // ================== 新增：蓝色进度环（根据睡眠时间绘制）=================
    final double progress = (sleepHours / 8.0).clamp(0.0, 1.0); // 最大8小时
    final double sweepAngle = progress * 2 * math.pi;           // 0~360°
// 从正上方（-90°）开始顺时针绘制
    final double startAngle = -math.pi / 2;    final bluePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF4285F4)   // 蓝色（可自行改颜色）
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    // 从顶部（12点钟位置）开始顺时针绘制
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,     // 从正上方开始
      sweepAngle,
      false,
      bluePaint,
    );
    // 计算起点和终点坐标
    final Offset startPoint = Offset(
      center.dx + radius * math.cos(startAngle),
      center.dy + radius * math.sin(startAngle),
    );

    final double endAngle = startAngle + sweepAngle;
    final Offset endPoint = Offset(
      center.dx + radius * math.cos(endAngle),
      center.dy + radius * math.sin(endAngle),
    );

    // ================== 橙色小圆点（固定在正上方起点）=================
    // 只有睡眠时间 < 8小时才画橙色点（≥8小时时起点和终点重合，只显示月亮）
    if (sleepHours < 8.0) {
      canvas.drawCircle(
        startPoint,
        7.5,
        Paint()..color = const Color(0xFFFFB74D), // 橙黄色
      );
    }

    // ================== 蓝色月牙（在进度终点）=================
    if (progress > 0.02) {   // 避免进度极小时月牙重叠
      // 大月亮
      canvas.drawCircle(endPoint, 8.5, Paint()..color = const Color(0xFF4285F4));

      // // 小月亮挖空形成月牙
      // canvas.drawCircle(
      //   Offset(endPoint.dx + 3.8, endPoint.dy - 1.2),
      //   7.8,
      //   Paint()..color = Colors.white,
      // );
    }
  }
@override
  bool shouldRepaint(covariant SleepPaint oldDelegate) =>
      sleepHours != oldDelegate.sleepHours;
}

class SleepCanvas extends StatefulWidget {
  final double sleepHours;   // ← 新增：传入睡眠小时数

  const SleepCanvas({
    Key? key,
    required this.sleepHours,
  }) : super(key: key);

  @override
  _SleepCanvasState createState() => _SleepCanvasState();
}

class _SleepCanvasState extends State<SleepCanvas> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(80.w, 80.h),
      painter: SleepPaint(sleepHours: widget.sleepHours),
    );
  }
}