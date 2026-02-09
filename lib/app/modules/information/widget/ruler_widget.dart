import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/modules/information/widget/height_painter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RulerWidget extends StatelessWidget {
  const RulerWidget({
    Key? key,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
    required this.visibleHeight,
    required this.offset,
    required this.targetOffset,
    required this.tickSpacing,
    required this.minValue,
    required this.maxValue, required this.unit,
    
  }) : super(key: key);
  final Function(DragUpdateDetails) onVerticalDragUpdate;
  final Function(DragEndDetails) onVerticalDragEnd;
  final double visibleHeight;
  final RxDouble offset;
  final RxDouble targetOffset;
  final double tickSpacing;
  final double minValue;
  final double maxValue;
  final String unit;

  // 当前选中的高度值（中间指示线对应的值）
  double get currentValue {
    final double firstTickValue = minValue + (-offset.value / tickSpacing);
    final double centerTickOffset = visibleHeight / 2 / tickSpacing;
    return (firstTickValue + centerTickOffset).clamp(minValue, maxValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // 可拖动的尺子本体
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: onVerticalDragUpdate,
              onVerticalDragEnd: onVerticalDragEnd,
              child: Container(
                // width: 180.w,
                width: double.infinity,
                // clipBehavior: Clip.none,           // ← 关键：禁止裁剪，让刻度线可以超出圆角
                height: visibleHeight,
                // decoration: BoxDecoration(
                //   color: Colors.grey[50],
                //   borderRadius: BorderRadius.circular(12),
                // ),
                child: Obx(
                  () => TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: offset.value,
                      end: targetOffset.value,
                    ),
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    builder: (context, animatedValue, child) {
                      return CustomPaint(
                        size: Size(180.w, visibleHeight),
                        painter: HeightRulerPainter(
                          offset: animatedValue, // 使用动画过渡值
                          tickSpacing: tickSpacing,
                          visibleHeight: visibleHeight,
                          minValue: minValue,
                          maxValue: maxValue,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // 固定在中间的数值显示
            Positioned(
              left: 80.w,
              child: Obx(
                () => Text(
                  '${currentValue.round().toStringAsFixed(0)} $unit',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
