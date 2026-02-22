import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TemperaturePaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 边框粗细（建议 7~10，根据视觉调整）
    final double strokeWidth = 8.0;

    // 半径（防止边框被裁剪）
    final double radius =
        math.min(size.width, size.height) / 2 - strokeWidth / 2;
        double _toRadian(double degree) => degree * math.pi / 180;



        // ===== 统一角度管理（改这里就行）=====
    final double startDegree = 120;   // ← 从左下开始绘画，改这个数字即可
    final double sweepDegree = 300;   // 扫过角度

    final double startAngle = _toRadian(startDegree);
    final double sweepAngle = _toRadian(sweepDegree);

    // 🔥 温度风格 SweepGradient（最推荐！）
    final gradient = SweepGradient(
      center: Alignment.center,                    // 以圆心为中心
      startAngle: startAngle, // 从正上方（12点钟方向）开始
      endAngle: startAngle + sweepAngle, // 旋转一圈半（完整覆盖）
      colors: const [
        Color(0xFFFFEA7A), 
        Color(0xFF00F787), // 
        Color(0xFF1EF778), // 
        Color(0xFF4CAF50), // 绿色
        Color(0xFFFFEA7A), 
        Color(0xFFFD3968), // 橙黄
      ],
      stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0], // 颜色分布位置
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..strokeCap = StrokeCap.round; // 让接头更圆润
    // 绘制渐变圆环
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,   // 使用变量
      sweepAngle,   // 使用变量
      false,
      paint,
    );
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
