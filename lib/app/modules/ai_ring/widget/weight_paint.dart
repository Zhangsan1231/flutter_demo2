import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class WeightPaint extends CustomPainter {
  final double value; // ← 现在接收的是真实体重（kg），范围 30~90

  WeightPaint({this.value = 60.0}); // 默认60kg（中间位置）
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final center = Offset(size.width / 2, (size.height / 2) + 10);
    final radius = 60.0;

    final onePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.withOpacity(0.25)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      onePaint,
    );
    final twoPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.withOpacity(0.25)
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 8),
      math.pi,
      math.pi,
      false,
      twoPaint,
    );
    // ================== twoPaint 现在跟随指针进度渲染（只画到指针位置）=================
    // 计算当前指针对应的进度（和指针完全同步）
    final double progressColor = ((value.clamp(30.0, 90.0) - 30.0) / 60.0).clamp(0.0, 1.0);
    final double twoSweepAngle = progressColor * math.pi;   // ← 只绘制到指针位置

    final colorPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF00C4FF)   // ← 这里改颜色！（你原来是灰色，现在可以改成你想要的颜色）
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 8),
      math.pi,           // 从左侧开始
      twoSweepAngle,     // ← 关键：只画到当前指针位置
      false,
      colorPaint,
    );

    // ================== 新增：内部 30 个刻度线 ==================
    // 总共 30 个刻度，均匀分布在 180° 半圆上
    // 1、5、10、15、20、25、30 为长刻度，其余为短刻度
    final Paint tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors
          .black54 // 可改颜色
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final double tickOuterRadius = radius - 8 - 8; // 从内弧内侧一点开始画

    for (int i = 0; i < 30; i++) {
      final int label = i + 1; // 对应数值 1~30
      final bool isLong =
          (label == 1) || (label % 5 == 0); // 1、5、10、15、20、25、30 为长刻度

      final double tickLength = isLong ? 7.0 : 3.0; // 长刻度13，短刻度7（可自行调整）

      final double angle = math.pi + i * (math.pi / 29.0); // 30个刻度 → 29个间隔

      // 刻度外端点
      final Offset outerPoint = Offset(
        center.dx + tickOuterRadius * math.cos(angle),
        center.dy + tickOuterRadius * math.sin(angle),
      );

      // 刻度内端点
      final Offset innerPoint = Offset(
        center.dx + (tickOuterRadius - tickLength) * math.cos(angle),
        center.dy + (tickOuterRadius - tickLength) * math.sin(angle),
      );

      canvas.drawLine(outerPoint, innerPoint, tickPaint);
    }

    final centerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Color(0x592E71FB)
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, 5, centerPaint);

    // ================== 新增：黑色指针（完全匹配图片风格）=================
    final double progress = ((value.clamp(30.0, 90.0) - 30.0) / 60.0).clamp(
      0.0,
      1.0,
    );
// 关键修复：使用 29 个间隔精确映射（30个刻度之间有29个间隔）
    // final double pointerAngle = math.pi + progress * 29 * (math.pi / 29);
    final double pointerAngle = math.pi + progress * math.pi - 0.05;   // -0.015 是精确微调（可改成 -0.02 或 0）
    final double pointerLength = radius - 25; // 指针长度（几乎到刻度）
    final double needleWidth = 4.0; // 指针最宽处
    final double needleBackLength = 2.0; // ← 关键修改！缩短尾部长度（原来8，现在5.5），底部不再超出圆心

    final Paint needlePaint = Paint()
      ..color = Color(0xff575757)
      ..style = PaintingStyle.fill;

    final Path path = Path();

    // 指针尖端（细长）
    final Offset tip = Offset(
      center.dx + pointerLength * math.cos(pointerAngle),
      center.dy + pointerLength * math.sin(pointerAngle),
    );

    // 指针尾部两侧（稍宽）
    final Offset tailLeft = Offset(
      center.dx +
          needleBackLength * math.cos(pointerAngle + math.pi) -
          needleWidth / 2 * math.cos(pointerAngle - math.pi / 2),
      center.dy +
          needleBackLength * math.sin(pointerAngle + math.pi) -
          needleWidth / 2 * math.sin(pointerAngle - math.pi / 2),
    );
    final Offset tailRight = Offset(
      center.dx +
          needleBackLength * math.cos(pointerAngle + math.pi) +
          needleWidth / 2 * math.cos(pointerAngle - math.pi / 2),
      center.dy +
          needleBackLength * math.sin(pointerAngle + math.pi) +
          needleWidth / 2 * math.sin(pointerAngle - math.pi / 2),
    );

    path.moveTo(tailLeft.dx, tailLeft.dy);
    path.lineTo(tip.dx, tip.dy);
    path.lineTo(tailRight.dx, tailRight.dy);
    path.close();

    canvas.drawPath(path, needlePaint);

    // // 指针尾部加一个小圆头（更精致）
    // canvas.drawCircle(
    //   center,
    //   4.5,
    //   Paint()..color = Colors.black,
    // );
  }

  @override
  bool shouldRepaint(covariant WeightPaint oldDelegate) =>
      oldDelegate.value != value; // ← 关键修复
}

class WeightConvas extends StatefulWidget {
  final double currentValue; // ← 这里改成你要显示的值（0~30）

  WeightConvas({super.key, required this.currentValue});

  @override
  _WeightConvasState createState() => _WeightConvasState();
}

class _WeightConvasState extends State<WeightConvas> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(96.w, 96.h),
      painter: WeightPaint(value: widget.currentValue), // ← 必须传入 value
    );
  }
}
