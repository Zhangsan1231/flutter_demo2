import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 心率波动画笔（完全在圆形内部，支持动画 + 传入值）
class HeartRatePaint extends CustomPainter {
  final double bpm;       // 外界传入的心率值（例如 72）
  final double wavePhase; // 动画相位（由 AnimationController 驱动）

  HeartRatePaint({
    required this.bpm,
    this.wavePhase = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);
    final radius = 50.0;
    double _toRadian(double degree) => degree * math.pi / 180;

    // ================== 你原来的3个圆弧（完全不动）=================
    final onePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0x521C6BFF)
      ..strokeWidth = 1.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _toRadian(90),
      _toRadian(90),
      false,
      onePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _toRadian(-90),
      _toRadian(90),
      false,
      onePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 3),
      math.pi,
      math.pi * 2,
      false,
      onePaint,
    );

    // ================== 新增：心率波动曲线（在圆形内部）=================
    final wavePaint = Paint()
      ..color = const Color(0xFF81D4FA)   // 浅蓝心率波形颜色（可改）
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final Path wavePath = Path();

    // 波形位置：完全在圆形内部下方
    final double waveY = center.dy + radius * 0.42;
    final double waveStartX = center.dx - radius * 0.75;
    final double waveWidth = radius * 1.5;

    wavePath.moveTo(waveStartX, waveY);

    // 生成ECG风格波形（带明显QRS尖峰）
    for (int i = 0; i <= 78; i++) {
      final double t = i / 78.0;
      final double x = waveStartX + waveWidth * t;

      // 基础波 + 高频细节
      double yOffset = math.sin(t * math.pi * 8.5 + wavePhase) * 5.5;
      yOffset += math.sin(t * math.pi * 17 + wavePhase * 1.4) * 2.8;

      // 制造3个明显的心跳尖峰（更真实）
      if (t > 0.18 && t < 0.24) yOffset -= 13;
      if (t > 0.48 && t < 0.55) yOffset -= 11;
      // if (t > 0.79 && t < 0.85) yOffset -= 9.5;

      final double y = waveY + yOffset * (bpm / 72); // 心率越高波形略微越高

      wavePath.lineTo(x, y);
    }

    // 限制波形在圆形内部
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: radius)));
    canvas.drawPath(wavePath, wavePaint);
    canvas.restore();

    // ================== 中心大数字 + BPM + Normal 标签 ==================
    // 大数字
    final textPainter = TextPainter(
      text: TextSpan(
        text: bpm.toStringAsFixed(0),
        style: TextStyle(
          color: Colors.black,
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2 - 8),
    );

    // BPM 文字
    final bpmPainter = TextPainter(
      text: const TextSpan(
        text: 'BPM',
        style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500),
      ),
      textDirection: TextDirection.ltr,
    );
    bpmPainter.layout();
    bpmPainter.paint(
      canvas,
      Offset(center.dx + textPainter.width / 2 + 4, center.dy - 12),
    );

    // Normal 标签
    final normalPainter = TextPainter(
      text: const TextSpan(
        text: 'Normal',
        style: TextStyle(
          color: Color(0xFF4CAF50),
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    normalPainter.layout();
    normalPainter.paint(
      canvas,
      Offset(center.dx - normalPainter.width / 2, center.dy + 18),
    );
  }

  @override
  bool shouldRepaint(covariant HeartRatePaint oldDelegate) =>
      bpm != oldDelegate.bpm || wavePhase != oldDelegate.wavePhase;
}

/// 带动画的心率组件
class HeartRatrCanvas extends StatefulWidget {
  final double bpm;   // 外界传入的心率值

  const HeartRatrCanvas({Key? key, required this.bpm}) : super(key: key);

  @override
  State<HeartRatrCanvas> createState() => _HeartRatrCanvasState();
}

class _HeartRatrCanvasState extends State<HeartRatrCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // 流动速度（可改2~5秒）
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(76.w, 76.h),
          painter: HeartRatePaint(
            bpm: widget.bpm,
            wavePhase: _controller.value * math.pi * 2 * 1.5, // 流动速度倍数
          ),
        );
      },
    );
  }
}