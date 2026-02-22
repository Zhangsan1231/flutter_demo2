import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class BloodOxygenPaint extends CustomPainter {
  // final double progress;   // 0.0 ~ 1.0，建议传 0.95

  // BloodOxygenPaint({this.progress = 0.65});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 40.0;

    // ① 外层红色细圆环（和图片完全一致）
    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
      outerPaint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFF7A7A), Color(0xFFFF2C55)],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
      

    canvas.drawCircle(center, radius +4, outerPaint);

    // ② 内部液体渐变 + 波浪液面（核心）
    final fillPaint = Paint()..style = PaintingStyle.fill;
    fillPaint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFF7A7A), Color(0xFFFF2C55)],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    // 计算液体表面基准高度（progress越大，液面越高）
    // 公式：从圆的最底部往上抬 (radius * 2 * progress) 的距离
    final double baseY = center.dy + radius - (radius * 2 * 0.65);
// 创建 Path 对象，用于绘制液体形状
    final Path path = Path();

    // 从液体左侧起点开始（稍微向左多5像素，让边缘更自然）
    path.moveTo(center.dx - radius - 5, baseY);

    // 绘制超自然波浪（2.1个主波 + 小扰动，和图片波浪一模一样）
    // ── 绘制波浪液面 ──
    // 分成65段（越多越平滑），每段计算x坐标和波浪y偏移
    const int segments = 65;      // 分段数（可调节平滑度）
    const double amplitude = 10; // 波浪幅度（可调节波浪高度）

    for (int i = 0; i <= segments; i++) {
      final double t = i / segments;
      final double x = center.dx - radius + (radius * 2) * t;

      final double wave = math.sin(t * math.pi * 4.2) * amplitude +
                          math.sin(t * math.pi * 8.1) * (amplitude * 0.4);

      path.lineTo(x, baseY + wave);
    }

    // 封闭到底部
    path.lineTo(center.dx + radius + 5, center.dy + radius + 10);
    path.lineTo(center.dx - radius - 5, center.dy + radius + 10);
    path.close();

    // Clip到圆内，让液体边缘完美贴合圆形
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: radius)));
    canvas.drawPath(path, fillPaint);
    canvas.restore();

    // ③ 小气泡（真实血氧仪感觉）
    final bubblePaint = Paint()
      ..color = Colors.white.withOpacity(0.75)
      ..style = PaintingStyle.fill;

    // 4个气泡位置（你可以随意调整坐标让它更自然）
    canvas.drawCircle(Offset(center.dx - 5, center.dy + 25), 3.0, bubblePaint);
    canvas.drawCircle(Offset(center.dx + 1, center.dy + 30), 3.5, bubblePaint);
    canvas.drawCircle(Offset(center.dx +2, center.dy + 20), 2.0, bubblePaint);
    // canvas.drawCircle(Offset(center.dx + 9, center.dy + 1), 2.1, bubblePaint);
    // ④ 中间 95% 文字（和图片字体大小、位置完全一致）
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(0.65 * 100).round()}%',
        style:  TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2 +12 ),
    );
  }

  @override
  bool shouldRepaint(covariant BloodOxygenPaint oldDelegate) =>
      false;
}

class BloodOxygenCanvas extends StatelessWidget {
  // final double progress;   // 直接传百分比即可

   BloodOxygenCanvas({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
    //  size: Size(72.w, 72.h),
      painter: BloodOxygenPaint(),
    );
  }
}