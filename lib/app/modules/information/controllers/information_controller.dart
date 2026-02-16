import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/data/enum/gender_enum.dart';
import 'package:flutter_demo2/app/data/repository/default_repository_impl.dart';
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

  // 每条刻度间隔像素（可根据需求调整）
  final double tickSpacing = 20.0;

  // 可见刻度数量（大约）
  final int visibleTicks = 15;

  // 滑动偏移（Rx 响应式）
  final RxDouble offset = 0.0.obs;

  // 可见区域高度（固定）
  final double visibleHeight = 240.0.h;

  // 当前选中的高度值（中间指示线对应的值）
  // double get currentValue {
  //   final double firstTickValue = minValue + (-offset.value / tickSpacing);
  //   final double centerTickOffset = visibleHeight / 2 / tickSpacing;
  //   return (firstTickValue + centerTickOffset).clamp(minValue, maxValue);
  // }
  // ==================== 体重尺子相关 ====================
  final double weightMinValue = 30;
  final double weightMaxValue = 150;

  final RxDouble weightOffset = 0.0.obs;
  final RxDouble weightTargetOffset = 0.0.obs;
  // 体重输入框控制器（用于双向绑定）
  final weightController = TextEditingController(text: '60');
  // 当前选中的体重值（响应式，供 UI 实时显示）
  final currentWeight = 60.0.obs; // RxDouble，默认 60 kg

  // 计算当前体重值（每次调用时更新 Rx）
  double get currentWeightValue {
    final double firstTickValue =
        weightMinValue + (-weightOffset.value / tickSpacing);
    final double centerTickOffset = visibleHeight / 2 / tickSpacing;
    final double value = (firstTickValue + centerTickOffset).clamp(
      weightMinValue,
      weightMaxValue,
    );

    // 实时更新 Rx 变量，让 Obx 能感知变化
    currentWeight.value = value;

    return value;
  }

  // 体重滑动更新
  void onWeightDragUpdate(DragUpdateDetails details) {
  weightOffset.value += details.delta.dy;

  // 修正 clamp 范围：确保能滑到最左（minValue）和最右（maxValue）
  final double totalTicks = weightMaxValue - weightMinValue;  // 总刻度数（每1kg一格）
  final double maxOffset = (totalTicks - visibleTicks + 1) * tickSpacing; // 最大偏移（滑到最右）
  final double minOffset = 0;  // 最左偏移为 0（显示 minValue）

  weightOffset.value = weightOffset.value.clamp(-maxOffset, minOffset);
  weightTargetOffset.value = weightOffset.value;

  // 实时更新当前值
  currentWeight.value = currentWeightValue;
}

  // 体重滑动结束（吸附到 0.5 kg 或整数）
  void onWeightDragEnd(DragEndDetails details) {
    final double current = currentWeightValue;
    final double targetValue = (current * 2).round() / 2; // 吸附到 0.5 kg

    final double centerOffsetInTicks = visibleHeight / 2 / tickSpacing;
    double target =
        -(targetValue - weightMinValue - centerOffsetInTicks) * tickSpacing;

    final double totalTicks = (weightMaxValue - weightMinValue) / 1.0;
    final double maxOffset = (totalTicks - visibleTicks + 1) * tickSpacing;
    final double minOffset = 0;

    target = target.clamp(-maxOffset, minOffset);

    weightTargetOffset.value = target;
    currentWeight.value = targetValue;
  }

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

    // ==================== 设置身高默认值 170 cm ====================
    final double defaultHeight = 170.0;
    final double centerOffsetInTicks = visibleHeight / 2 / tickSpacing;
    final double initialHeightOffset =
        -(defaultHeight - minValue - centerOffsetInTicks) * tickSpacing;

    offset.value = initialHeightOffset.clamp(
      -(maxValue - minValue - visibleTicks + 1) * tickSpacing,
      0,
    );
    targetOffset.value = offset.value; // 同步目标偏移（动画起始点）

    // ==================== 设置体重默认值 60 kg ====================
    final double defaultWeight = 60.0;
    final double initialWeightOffset =
        -(defaultWeight - weightMinValue - centerOffsetInTicks) * tickSpacing;

    weightOffset.value = initialWeightOffset.clamp(
      -(weightMaxValue - weightMinValue - visibleTicks + 1) * tickSpacing,
      0,
    );
    weightTargetOffset.value = weightOffset.value;

    // 可选：同步输入框显示
    weightController.text = defaultWeight.toStringAsFixed(1);
  }

  // 当前选中的生日（初始为 null）
  final selectedBirthday = Rx<DateTime?>(null);

  // 选择生日的方法（供 BottomSheet 调用）
  Future<void> selectBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate:
          selectedBirthday.value ??
          DateTime.now().subtract(Duration(days: 365 * 20)), // 默认20岁
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xff3262FF)),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xff3262FF)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedBirthday.value) {
      selectedBirthday.value = picked;
      print('用户选择了生日：${picked.toString().substring(0, 10)}');
    }
  }

  Future<void> nextPatchInfo() async {
    
    if (firstName.isEmpty) {
      logger.d('请填写firstName');
      Get.snackbar('请填写firstName','');
      return;
    }
    if (lastName.isEmpty) {
      logger.d('请填写lastName');
      Get.snackbar('请填写lastName','');
      return;
    }

    // if(currentValue.round()){
    //   logger.d('请填写firstName');
    //   return ;
    // }
    // if (selectedBirthday.value == null) {
    //   logger.d('请输入生日');
    //   Get.snackbar('请填写生日','');
      
    //   return;
    // }
    Map<String,Object> map = {
      'name': firstName + lastName,
      'gender': selectedGender.value.label,
      'height': currentValue.round(),
      'weight': currentWeightValue.round(),
      'birthdate': selectedBirthday.value!.toUtc().toIso8601String(),
      
    };
    bool result = await DefaultRepositoryImpl().patchInfo(map);
    logger.d('提交测试: ${result}');

  }
}
