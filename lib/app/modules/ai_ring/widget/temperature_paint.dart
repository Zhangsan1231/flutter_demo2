import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TemperaturePaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 圆心（稍微向下偏移，和你的图片位置一致）
    final center = Offset(size.width / 2, (size.height / 2) + 11.h);

    // 圆的半径
    final radius = size.width / 2 - 10;

    // ────────────────────── 1. 最外层浅色圆 ──────────────────────
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = const Color(0xffBFFFE0);

    canvas.drawCircle(center, radius, circlePaint);

    // ────────────────────── 2. 绘制刻度数字 34~40（从底部偏左开始） ──────────────────────
    final numbers = [34, 35, 36, 37, 38, 39, 40];

    // 关键调整参数（你想要的效果核心在这里）
    const double startAngle = math.pi + 0.65;   // ← 从底部左侧一点开始（不是左侧水平）
    const double totalAngle = math.pi * 1.7;    // ← 总扫过角度，让37正好在顶部

    for (int i = 0; i < numbers.length; i++) {
      // 计算每个数字的角度
      final double angle = startAngle + (totalAngle * i / (numbers.length - 1));

      // 数字距离圆心的距离（放在圆外面一点）
      final double textRadius = radius + 22.w;

      // 计算文字坐标
      final double x = center.dx + textRadius * math.cos(angle);
      final double y = center.dy + textRadius * math.sin(angle);

      // 绘制数字
      final textPainter = TextPainter(
        text: TextSpan(
          text: numbers[i].toString(),
          style: TextStyle(
            color: const Color(0xff333333),
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,   // 水平居中
          y - textPainter.height / 2,  // 垂直居中
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



class TemperatureCanvas extends StatefulWidget {
  TemperatureCanvas({Key? key}) : super(key: key);

  @override
  _TemperatureCanvasState createState() => _TemperatureCanvasState();
}

class _TemperatureCanvasState extends State<TemperatureCanvas> {
  @override
  Widget build(BuildContext context) {
   return CustomPaint(
      size:  Size(81.w, 81.h), // 建议加上固定大小，避免布局问题
      painter: TemperaturePaint(),
    );
  }
}