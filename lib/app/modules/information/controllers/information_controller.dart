import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/data/enum/gender_enum.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:simple_ruler_picker/simple_ruler_picker.dart';



class InformationController extends BaseController {

  // 定义控制器（必须在 onClose 中 dispose）
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  // 方便获取值的 getter（可选）
  String get firstName => firstNameController.text.trim();
  String get lastName => lastNameController.text.trim();
  //TODO: Implement InformationController

  final count = 0.obs;
 // 当前选中的性别（初始为保密）
  final selectedGender = Rx<Gender>(Gender.confidential);

  // 选择性别的方法
  void selectGender(Gender gender) {
    selectedGender.value = gender;
    print('用户选择了性别：${gender.label}');
    // Get.back();  // 关闭弹窗（可选，根据你的需求）
  }




  final double minValue = 90;
  final double maxValue = 280;
  final double weightMinValue = 40;
  final double weightMaxValue = 150;
  // 每条刻度间隔像素（可根据需求调整）
  final double tickSpacing = 20.0;

  // 可见刻度数量（大约）
  final int visibleTicks = 15;

  // 滑动偏移（Rx 响应式）
  final RxDouble offset = 0.0.obs;

  // 可见区域高度（固定）
  final double visibleHeight = 240.0.h;

  // 当前选中的高度值（中间指示线对应的值）
  double get currentValue {
    final double firstTickValue = minValue + (-offset.value / tickSpacing);
    final double centerTickOffset = visibleHeight / 2 / tickSpacing;
    return (firstTickValue + centerTickOffset).clamp(minValue, maxValue);
  }

  // 滑动更新
  void onVerticalDragUpdate(DragUpdateDetails details) {
    offset.value += details.delta.dy;

    final double totalRange = maxValue - minValue;
    final double maxOffset = (totalRange - visibleTicks + 1) * tickSpacing;
    final double minOffset = -tickSpacing * (visibleTicks ~/ 2);

    offset.value = offset.value.clamp(-maxOffset, minOffset);

    // 拖动中也同步目标值（让动画跟随实时拖动）
    targetOffset.value = offset.value;
  }

  // 可选：手指抬起后吸附到最近的整数厘米
  void onVerticalDragEnd(DragEndDetails details) {
    final double currentCenterValue = currentValue;
    final double targetValue = currentCenterValue.round().toDouble();

    final double centerOffsetInTicks = visibleHeight / 2 / tickSpacing;
    double target =
        -(targetValue - minValue - centerOffsetInTicks) * tickSpacing;

    // clamp
    final double totalRange = maxValue - minValue;
    final double maxOffset = (totalRange - visibleTicks + 1) * tickSpacing;
    final double minOffset = -tickSpacing * (visibleTicks / 2);
    target = target.clamp(-maxOffset, minOffset);

    // 更新目标值 → TweenAnimationBuilder 会自动动画过渡
    targetOffset.value = target;
  }

  final RxDouble animatedOffset = 0.0.obs;
  final RxDouble targetOffset = 0.0.obs;

  // 初始化时让 targetOffset 和 offset 同步
  @override
  void onInit() {
    super.onInit();
    targetOffset.value = offset.value;
  }
}
