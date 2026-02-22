import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 血压半圆仪表画笔（CustomPainter）
/// 功能：根据传入的 label（偏低/正常/轻度/中度/重度）动态高亮半圆
/// 核心逻辑：从当前等级开始，向右一直到“重度”全部高亮彩色
class BloodPressurePaint extends CustomPainter {
  final String label; // 传入的血压等级文字

  BloodPressurePaint({super.repaint, required this.label});

  @override
  void paint(Canvas canvas, Size size) {
    // 画布中心点（Y轴放在下方，让半圆向上拱起，视觉更美观）
    final center = Offset(size.width / 2, size.height * 0.75);

    // 半圆半径（固定60像素）
    final radius = 60.0;

    // ────────────────────── 颜色映射表 ──────────────────────
    // 重度使用橙色，其余等级使用渐进颜色
    final Map<String, Color> levelColors = {
      '重度': const Color(0xFFFF9800), // 重度 = 橙色（你指定的颜色）
      '中度': const Color(0xFFFF5722),
      '轻度': const Color(0xFFFFC107),
      '正常': const Color(0xFF4CAF50),
      '偏低': const Color(0xFF81D4FA),
    };

    final Color unifiedColor = levelColors[label] ?? Colors.grey;

    // ────────────────────── label → 第几段映射 ──────────────────────
    // 从左到右：偏低=第1段，正常=第2段...重度=第5段
    final Map<String, int> levelToSegment = {
      '偏低': 1,
      '正常': 2,
      '轻度': 3,
      '中度': 4,
      '重度': 5,
    };

    final int currentSegment = levelToSegment[label] ?? 5; // 当前是第几段

    // ────────────────────── 公共参数（5段半圆） ──────────────────────
    const int totalSegments = 5; // 总共5段
    const double gapAngle = 0.2; // 每段之间的间隔角度（弧度）
    final double totalSweep = math.pi; // 总共180°半圆
    final double availableSweep = totalSweep - (totalSegments - 1) * gapAngle;
    final double eachSegmentSweep = availableSweep / totalSegments; // 每一段实际占的角度

    // ────────────────────── ① 最外层5段弧线（从当前段开始向右全部高亮） ──────────────────────
    // 例如：中度 → 第4段和第5段高亮；轻度 → 第3、4、5段高亮
    double currentStartAngle = math.pi; // 从左侧（180°）开始画

    for (int i = 0; i < totalSegments; i++) {
      // 当前段及右侧所有段都高亮（这就是你想要的“向右一直到重度”）
      final bool isActive = (i + 1) >= currentSegment;

      final segmentPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = isActive ? unifiedColor : Colors.grey.withOpacity(0.25)
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentStartAngle,
        eachSegmentSweep,
        false,
        segmentPaint,
      );

      currentStartAngle += eachSegmentSweep + gapAngle; // 下一段起点
    }

    // ────────────────────── ② 中间细分割线（装饰用，保持浅灰） ──────────────────────
    final segmentPaintTwo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.grey.withOpacity(0.25)
      ..strokeCap = StrokeCap.round;

    const int totalSegmentsTwo = 25; // 更细的分割线（视觉更精致）
    const double gapAngleTwo = 0.1;
    final double availableSweepTwo =
        math.pi - (totalSegmentsTwo - 1) * gapAngleTwo;
    final double eachSegmentSweepTwo = availableSweepTwo / totalSegmentsTwo;

    double currentStartAngleTwo = math.pi;
    for (int i = 0; i < totalSegmentsTwo; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 4),
        currentStartAngleTwo,
        eachSegmentSweepTwo,
        false,
        segmentPaintTwo,
      );
      currentStartAngleTwo += eachSegmentSweepTwo + gapAngleTwo;
    }

    // ────────────────────── ③ 粗半圆（整体连续，只从当前段向右高亮） ──────────────────────
    // 第一步：画完整的浅灰色粗半圆（连续一条，不中断）
    final bgThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.grey.withOpacity(0.25)
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 12),
      math.pi,
      math.pi,
      false,
      bgThickPaint,
    );

    // 第二步：计算从当前段开始到最右边的总角度
    final double sweepFromCurrent =
        (totalSegments - currentSegment + 1) * eachSegmentSweep +
        (totalSegments - currentSegment) * gapAngle;

    // 当前段的起始角度
    final double startAngleCurrent =
        math.pi + (currentSegment - 1) * (eachSegmentSweep + gapAngle);

    // 第三步：叠加彩色粗弧（覆盖灰色，实现连续高亮）
    final activeThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = unifiedColor
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 12),
      startAngleCurrent,
      sweepFromCurrent,
      false,
      activeThickPaint,
    );

    // ────────────────────── ④ 内层扇形（同步从当前段向右高亮） ──────────────────────
    final foruPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = unifiedColor
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 24),
      math.pi,
      math.pi,
      true,
      foruPaint,
    );

    // ────────────────────── ⑤ 绘制文字（显示当前 label） ──────────────────────
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: unifiedColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height - 5,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant BloodPressurePaint oldDelegate) =>
      label != oldDelegate.label;
}

class BloodPressureCanvas extends StatefulWidget {
  final String label;
  const BloodPressureCanvas({Key? key, required this.label}) : super(key: key);

  @override
  State<BloodPressureCanvas> createState() => _BloodPressureCanvasState();
}

class _BloodPressureCanvasState extends State<BloodPressureCanvas> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 160), // 建议加上固定大小，避免布局问题
      painter: BloodPressurePaint(label: widget.label),
    );
  }
}
