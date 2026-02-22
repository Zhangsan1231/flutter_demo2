import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TemperaturePaint extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {
  final center = Offset(size.width / 2, size.height / 2);

  final double strokeWidth = 8.0;
  final double radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;

  double _toRadian(double degree) => degree * math.pi / 180;

  // ================== 角度控制（改这里就生效）==================
  final double startDegree = 120;   // ← 你想从哪里开始就改这个（-90=顶部，0=右侧，120=左下方）
  final double sweepDegree = 300;   // ← 圆弧长度

  final double startAngle = _toRadian(startDegree);
  final double sweepAngle = _toRadian(sweepDegree);
    final double startAngleTwo = _toRadian(startDegree-30);


  final Rect arcRect = Rect.fromCircle(center: center, radius: radius);

  // ================== 关键修复：GradientRotation ==================
  final gradient = SweepGradient(
    center: Alignment.center,
    startAngle: 0.0,                    // 固定为0
    endAngle: sweepAngle,               // 只扫过我们需要的角度长度
    colors: const [
      // Color(0xFF42A5F5), // 冷：蓝
      Color(0xffFFEA7A),
      Color(0xFFFEF400),
      Color(0xFF00F787),
      Color(0xFF1EF778),
      Color(0xffFAE100),
      Color(0xFFFFA726),
      Color(0xffFD3968)
      // Color(0xFFEF5350), // 热：红
      // Colors.black,
    ],
    stops: const [0.0, 0.2, 0.3, 0.45,0.6, 0.8, 0.99],
    tileMode: TileMode.clamp,
    transform: GradientRotation(startAngleTwo),   // ← 核心！旋转渐变到指定起点
  );

  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
    ..shader = gradient.createShader(arcRect);

  // 绘制圆弧（角度和渐变已完全对齐）
  canvas.drawArc(arcRect, startAngle, sweepAngle, false, paint);

  //绘制内部圆
  final circlePaint = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 1.0
    ..color = Color(0xffBFFFE0);
    canvas.drawCircle(center, radius-10, circlePaint);
}
 
 
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TemperatureCanvas extends StatefulWidget {
  const TemperatureCanvas({Key? key}) : super(key: key);

  @override
  State<TemperatureCanvas> createState() => _TemperatureCanvasState();
}

class _TemperatureCanvasState extends State<TemperatureCanvas> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(81.w, 81.h), painter: TemperaturePaint());
  }
}
