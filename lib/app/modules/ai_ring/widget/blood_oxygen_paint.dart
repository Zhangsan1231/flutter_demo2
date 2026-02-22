import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 血氧波浪画笔（支持左右流动动画）
/// 功能：绘制一个带渐变液体、流动波浪液面、小气泡和百分比文字的圆形血氧仪
/// 核心特性：通过 wavePhase 参数实现波浪左右缓缓流动的效果
class BloodOxygenPaint extends CustomPainter {
  final double wavePhase; // 0~2π，控制波浪左右流动的相位（由动画控制器驱动）

  /// 构造函数，默认相位为 0.0
  BloodOxygenPaint({this.wavePhase = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    // 计算画布中心点和圆形半径（当前尺寸下 radius=40 比较合适）
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 40.0;

    // ────────────────────── ① 外层红色细圆环 ──────────────────────
    // 使用渐变色边框，比纯色更立体
    final outerPaint = Paint()
      ..style = PaintingStyle
          .stroke // 只绘制边框，不填充
      ..strokeWidth = 3.0; // 边框粗细（可调节）

    outerPaint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFF7A7A), Color(0xFFFF2C55)], // 浅红 → 深红渐变
    ).createShader(Rect.fromCircle(center: center, radius: radius + 4));

    // 绘制外环（比液体半径大4像素，形成明显的外边框）
    canvas.drawCircle(center, radius + 4, outerPaint);

    // ────────────────────── ② 内部液体渐变 + 流动波浪液面（核心部分） ──────────────────────
    // 创建填充画笔
    final fillPaint = Paint()..style = PaintingStyle.fill;

    // 内部液体使用相同的渐变色（上浅下深，更有液体质感）
    fillPaint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFF7A7A), Color(0xFFFF2C55)],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    // 计算液体表面基准高度（0.65 表示 65% 高度，从底部向上抬升）
    final double baseY = center.dy + radius - (radius * 2 * 0.65);

    // 创建 Path 对象，用于绘制不规则的液体形状
    final Path path = Path();
    // 从左侧起点开始绘制（向左多5像素让边缘更自然）
    path.moveTo(center.dx - radius - 5, baseY);

    // ── 绘制流动波浪液面 ──
    const int segments = 78; // 分段数量（越多越平滑，性能消耗也略高）
    const double amplitude = 5; // 波浪幅度（当前小尺寸下 6.5 比较合适）

    for (int i = 0; i <= segments; i++) {
      final double t = i / segments; // t 从 0.0 到 1.0，横向进度
      final double x = center.dx - radius + (radius * 2) * t; // 计算当前 x 坐标

      // 关键动画逻辑：加入 wavePhase 实现左右流动
      // 使用两层不同频率和速度的正弦波叠加，产生更自然、丰富的波动效果
      final double wave =
          math.sin(t * math.pi * 4 + wavePhase) * amplitude +
          math.sin(t * math.pi * 5.6 + wavePhase * 1.3) * (amplitude * 0.32);

      path.lineTo(x, baseY + wave); // 连接到波浪上的点
    }

    // 封闭路径：从右侧波浪终点 → 圆形右下角 → 左下角 → 闭合，形成完整液体区域
    path.lineTo(center.dx + radius + 5, center.dy + radius + 10);
    path.lineTo(center.dx - radius - 5, center.dy + radius + 10);
    path.close();

    // 重要技巧：把液体限制在圆形内部（防止波浪超出圆圈）
    canvas.save(); // 保存画布状态
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.drawPath(path, fillPaint); // 真正绘制液体
    canvas.restore(); // 恢复画布状态

    // ────────────────────── ③ 小气泡（增加真实血氧仪质感） ──────────────────────
    final bubblePaint = Paint()
      ..color = Colors.white
          .withOpacity(0.75) // 半透明白色气泡
      ..style = PaintingStyle.fill;

    // 3个气泡（位置已针对小尺寸微调，你可以继续调整坐标）
    canvas.drawCircle(Offset(center.dx - 5, center.dy + 25), 2.5, bubblePaint);
    canvas.drawCircle(Offset(center.dx + 1, center.dy + 35), 3.0, bubblePaint);
    canvas.drawCircle(Offset(center.dx + 2, center.dy + 20), 2.0, bubblePaint);

    // ────────────────────── ④ 中间百分比文字 ──────────────────────
    // 使用 TextPainter 在 Canvas 上绘制文字（Flutter 中标准方式）
    final textPainter = TextPainter(
      text: TextSpan(
        text: '65%', // 当前固定显示 65%，后面可改为动态 progress
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp, // 使用 screenutil 自适应字体
          fontWeight: FontWeight.w500,
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(); // 计算文字实际宽高
    // 绘制文字：水平居中，垂直向下偏移 +12（看起来更自然）
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2 + 12,
      ),
    );
  }

  /// 性能优化：只有 wavePhase 发生变化时才重绘
  @override
  bool shouldRepaint(covariant BloodOxygenPaint oldDelegate) =>
      wavePhase != oldDelegate.wavePhase;
}

/// 带流动动画的血氧显示组件（StatefulWidget）
class BloodOxygenCanvas extends StatefulWidget {
  const BloodOxygenCanvas({Key? key}) : super(key: key);

  @override
  State<BloodOxygenCanvas> createState() => _BloodOxygenCanvasState();
}

class _BloodOxygenCanvasState extends State<BloodOxygenCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // 流动速度，可随意改（3~8秒都好看）
    )..repeat(); // 无限循环
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
        // 关键修复：乘以较大倍数（6.8），让波浪每次循环转很多圈 → 视觉完全无缝衔接
        final phase = _controller.value * math.pi * 2 * 2.0;

        return CustomPaint(
          size: Size(72.w, 72.h),
          painter: BloodOxygenPaint(wavePhase: phase),
        );
      },
    );
  }
}
