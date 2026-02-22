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
        final double textStartAngle = _toRadian(startDegree+20);
        final double textSweepAngle = _toRadian(260);   // ← 这里！改这个数字控制文字结束位置



  final Rect arcRect = Rect.fromCircle(center: center, radius: radius);

  // ================== 创建角度渐变 Shader（核心部分）=================
  // 为什么要用 SweepGradient？
  //   1. SweepGradient 是 Flutter 中唯一支持“绕中心旋转渐变”的渐变类型
  //   2. 它可以让颜色沿着圆弧方向自然过渡（蓝→绿→黄→橙→红），非常适合仪表盘、进度环
  //   3. LinearGradient 是直线渐变，RadialGradient 是从中心向外扩散，都不适合圆弧
  //   4. SweepGradient 默认从右侧（0度）顺时针开始，所以我们后面用 transform 旋转它
  final gradient = SweepGradient(
    center: Alignment.center,           // 为什么要用 Alignment.center？
                                        // 因为我们要让渐变以圆形的正中心为旋转中心
                                        // 如果不写这个，渐变中心会偏到左上角，导致颜色错位

    startAngle: 0.0,                    // 固定为0，让我们自己通过 transform 来控制起点
    endAngle: sweepAngle,               // 只扫过我们需要的角度长度（和圆弧长度一致）

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
    
    // transform: GradientRotation(startAngleTwo)
    // 为什么要用 GradientRotation？
    //   SweepGradient 默认从右侧0度开始顺时针旋转
    //   我们用 GradientRotation 把整个渐变“旋转”到我们想要的 startDegree-30 的位置
    //   这样就能让颜色起点和圆弧起点完美对齐
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


    // ================== 最外层刻度文字 34～40 ==================
    final double labelRadius = radius + strokeWidth + 18; // 向外偏移距离（可微调数字）
    final int minTemp = 34;
    final int steps = 6; // 34到40共7个点，6个间隔

    for (int i = 0; i <= steps; i++) {
      final double progress = i / steps;
      final double labelAngle = textStartAngle + (progress * textSweepAngle); //控制起始   // ← 使用上面定义的 textStartAngle 和 textSweepAngle

      final String label = (minTemp + i).toString();

      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 11,                    // 字体大小，可改
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // 计算文字在圆上的位置
      final double x = center.dx + labelRadius * math.cos(labelAngle);
      final double y = center.dy + labelRadius * math.sin(labelAngle);

      // 水平居中绘制（不旋转！）
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,     // 水平居中
          y - textPainter.height / 2,    // 垂直居中
        ),
      );

     
    }
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