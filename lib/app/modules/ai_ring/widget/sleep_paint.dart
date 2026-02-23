import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:async'; // 新增：用于 Completer

// 辅助函数：把 ImageProvider 转成 ui.Image
Future<ui.Image> loadUiImage(ImageProvider provider) async {
  final completer = Completer<ui.Image>();
  final stream = provider.resolve(const ImageConfiguration());
  stream.addListener(
    ImageStreamListener((ImageInfo info, bool synchronousCall) {
      completer.complete(info.image);
    }),
  );
  return completer.future;
}
class SleepPaint extends CustomPainter {
 
 final double sleepHours;
  final ui.Image? moonImage;   // 起点图片（月亮）
  final ui.Image? sunImage;    // 终点图片（太阳）

  SleepPaint({
    this.sleepHours = 0.0,
    this.moonImage,
    this.sunImage,
  });
 
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint // 计算画布中心点和圆形半径（当前尺寸下 radius=40 比较合适）
    final center = Offset(size.width / 2, (size.height / 2));
    final radius = 50.0;

    final onePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.withOpacity(0.25)
      ..strokeWidth = 8.0;
    canvas.drawCircle(center, radius, onePaint);
    final twoPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Color(0x141B6BFF)
      ..strokeWidth = 8.0;
    canvas.drawCircle(center, radius - 10, twoPaint);

    // ================== 新增：蓝色进度环（根据睡眠时间绘制）=================
    final double progress = (sleepHours / 8.0).clamp(0.0, 1.0); // 最大8小时
    final double sweepAngle = progress * 2 * math.pi; // 0~360°
    // 从正上方（-90°）开始顺时针绘制
    final double startAngle = -math.pi / 2;
    final bluePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color =
          const Color(0xFF4285F4) // 蓝色（可自行改颜色）
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    // 从顶部（12点钟位置）开始顺时针绘制

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, // 从正上方开始
      sweepAngle,
      false,
      bluePaint,
    );
    
    // 计算起点和终点坐标
    // final Offset startPoint = Offset(
    //   center.dx + radius * math.cos(startAngle),
    //   center.dy + radius * math.sin(startAngle),
    // );

    // final double endAngle = startAngle + sweepAngle;
    // final Offset endPoint = Offset(
    //   center.dx + radius * math.cos(endAngle),
    //   center.dy + radius * math.sin(endAngle),
    // );

  // ================== 新增：绘制图片 ==================
    const double iconSize =35.0;   // 图片显示大小，可自行调整
    final double iconRadius = radius - 5.0;   // ← 这里调整！负数=向内缩（推荐 -8 ~ -15）
final Offset startPoint = Offset(
      center.dx + iconRadius * math.cos(startAngle),
      center.dy + iconRadius * math.sin(startAngle),
    );

    final double endAngle = startAngle + sweepAngle;
    final Offset endPoint = Offset(
      center.dx + iconRadius * math.cos(endAngle),
      center.dy + iconRadius * math.sin(endAngle),
    );
    // 绘制起点月亮（固定在顶部）
    if (moonImage != null) {
      _drawImageCentered(canvas, moonImage!, startPoint, iconSize);
    }

    // 绘制终点太阳（加白色小底盘更清晰）
    if (sunImage != null && progress > 0.03 && sleepHours <8) {  // 进度太小时不画，避免和起点重叠
      // 白色底盘
      // canvas.drawCircle(endPoint, iconSize / 2 + 3, Paint()..color = Colors.white);
      _drawImageCentered(canvas, sunImage!, endPoint, iconSize);
    }
  }

  // 辅助方法：居中绘制图片
  void _drawImageCentered(Canvas canvas, ui.Image image, Offset center, double size) {
    final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromCenter(
      center: center,
      width: size,
      height: size,
    );
    canvas.drawImageRect(image, srcRect, dstRect, Paint()..filterQuality = FilterQuality.high);
  }

    @override
  bool shouldRepaint(covariant SleepPaint oldDelegate) =>
      sleepHours != oldDelegate.sleepHours ||
      moonImage != oldDelegate.moonImage ||   // ← 新增
      sunImage != oldDelegate.sunImage;       // ← 新增
}

class SleepCanvas extends StatefulWidget {
  
  final double sleepHours; // ← 新增：传入睡眠小时数

  const SleepCanvas({Key? key, required this.sleepHours, }) : super(key: key);

  @override
  _SleepCanvasState createState() => _SleepCanvasState();
}
class _SleepCanvasState extends State<SleepCanvas> {
  ui.Image? moonImg;
  ui.Image? sunImg;

  @override
  void initState() {
    super.initState();
    _loadImages();   // ← 记得调用
  }

  Future<void> _loadImages() async {
    try {
      // 月亮（起点）
      final moonProvider = Assets.images.slepp.provider();   // 注意你的文件名是 slepp？
      moonImg = await loadUiImage(moonProvider);

      // 太阳（终点）
      final sunProvider = Assets.images.sleepSun.provider();
      sunImg = await loadUiImage(sunProvider);

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('图片加载失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(80.w, 80.h),
      painter: SleepPaint(
        sleepHours: widget.sleepHours,
        moonImage: moonImg,
        sunImage: sunImg,
      ),
    );
  }
}