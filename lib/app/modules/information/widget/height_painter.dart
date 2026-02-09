import 'package:flutter/material.dart';

class HeightRulerPainter extends CustomPainter {
  // 滑动偏移量（像素），正值表示向下拖动（显示更小数值）
  final double offset;

  // 每条刻度之间的像素间距（越大刻度越稀疏）
  final double tickSpacing;

  // 可见区域的高度（决定了能看到多少条刻度）
  final double visibleHeight;

  // 最小/最大身高值（单位：cm）
  final double minValue;
  final double maxValue;

  HeightRulerPainter({
    required this.offset,
    required this.tickSpacing,
    required this.visibleHeight,
    required this.minValue,
    required this.maxValue,
  });

 @override
void paint(Canvas canvas, Size size) {
  final paint = Paint()
    ..color = Colors.black87
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke;

  final selectedPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke;

  // 边界三角形画笔（填充样式）
  final boundaryPaint = Paint()
    ..color = Colors.grey[600]!   // 你可以改成其他颜色，例如 Colors.blueGrey
    ..style = PaintingStyle.fill; // 改为填充

  // 计算顶部第一个刻度值
  final double firstTickValue = minValue + (-offset / tickSpacing);

  final double centerValue = firstTickValue + (visibleHeight / 2) / tickSpacing;
  final double selectedValue = centerValue.round().toDouble().clamp(minValue, maxValue);

  double currentValue = (firstTickValue.floor() - 2).toDouble().clamp(minValue, maxValue);

  // 绘制刻度线（排除靠近顶部和底部的普通刻度，避免与三角形重叠）
  while (currentValue <= maxValue) {
    final double y = (currentValue - firstTickValue) * tickSpacing;

    // 只在容器内部绘制，但排除顶部和底部靠近边缘的刻度
    if (y >= 20 && y <= visibleHeight - 20) {   // 留出 20px 空间给三角形
      final bool isSelected = (currentValue - selectedValue).abs() < 0.01;

      // 即使是选中刻度，也只在非边缘区域绘制（避免选中线刚好卡在边缘）
      if (isSelected && (y < 20 || y > visibleHeight - 20)) {
        // 如果选中刻度在边缘，可以选择不画或画短一点，这里先跳过
        currentValue += 1;
        continue;
      }

      final Paint currentPaint = isSelected ? selectedPaint : paint;
      double lineLength = 20;
      if (isSelected) {
        lineLength = 50;
      } else if (currentValue % 10 == 0) {
        lineLength = 40;
      } else if (currentValue % 5 == 0) {
        lineLength = 30;
      }

      final double startX = 10.0;
      final double endX = 10.0 + lineLength;

      canvas.drawLine(
        Offset(startX, y),
        Offset(endX, y),
        currentPaint,
      );
    }

    currentValue += 1;
    if (y > visibleHeight + tickSpacing * 2) break;
  }

  // ────────────────────────────────
  // 绘制顶部和底部的三角形（填充 + 方向已反转）
  // ────────────────────────────────

  const double triangleSize = 14.0;   // 可调整大小

  // 顶部三角形：尖端朝上（填充）
  final topTrianglePath = Path()
    ..moveTo(10.0, 0)                              // 左上
    ..lineTo(10.0 + triangleSize, 0)               // 右上
    ..lineTo(10.0 + triangleSize / 2, triangleSize) // 下尖端
    ..close();

  canvas.drawPath(topTrianglePath, boundaryPaint);

  // 底部三角形：尖端朝下（填充）
  final bottomTrianglePath = Path()
    ..moveTo(10.0, visibleHeight)                  // 左下
    ..lineTo(10.0 + triangleSize, visibleHeight)   // 右下
    ..lineTo(10.0 + triangleSize / 2, visibleHeight - triangleSize) // 上尖端
    ..close();

  canvas.drawPath(bottomTrianglePath, boundaryPaint);
}
  @override
  bool shouldRepaint(covariant HeightRulerPainter oldDelegate) {
    // 当 offset 变化时才重新绘制（性能优化）
    return oldDelegate.offset != offset;
  }
}