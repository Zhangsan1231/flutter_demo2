import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/app/modules/information/widget/height_painter.dart';
import 'package:flutter_demo2/app/modules/information/widget/ruler_widget.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:simple_ruler_picker/simple_ruler_picker.dart';

import '../controllers/information_controller.dart';
import '../widget/information_widget.dart';

class InformationView extends BaseViews<InformationController> {
  InformationView({super.key})
    : super(
        bgImage: PageBackground(
          imagePath: Assets.images.backgronud.path, // 注意拼寫改成 background
          top: 0.0,
          left: 0.0,
          width: 375.w,
          // width: Get.width,           // 螢幕寬度
          // height: Get.height+MediaQuery.of(Get.context!).padding.top,         // 螢幕高度
          height: 812.w + MediaQuery.of(Get.context!).padding.top,
          fit: BoxFit.fitHeight, // 建議用 cover 全屏鋪滿
        ),
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // 看圖片顏色決定
      );

  @override
  Widget? appBar(BuildContext context) {
    // TODO: implement appBar
    return null;
  }

  @override
  Widget body(BuildContext context) {
    // TODO: implement body
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      // alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, //左侧对齐
        children: [
          Container(child: Column()),
          Gap(50.h),
          Text(
            'Basic',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Infomation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.h),
                  topRight: Radius.circular(24.h),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(24.h),
                  Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Color(0xff444444),
                    ),
                  ),
                  Gap(12.h),

                  firstTextInput(),

                  Gap(12.h),

                  lastTextInput(),
                  Gap(16.h),
                  Text(
                    'Gender',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Color(0xff444444),
                    ),
                  ),
                  Gap(12.h),
                  InkWell(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          width: double.infinity,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.h),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [Text('男'), Text('男'), Text('男')],
                          ),
                        ),
                      );
                      logger.d('性别点击测试');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.h,
                      ),
                      alignment: Alignment.centerRight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.h),
                        color: Color(0xffF5F6FA),
                      ),

                      child: Icon(Icons.home),
                    ),
                  ),

                  Gap(16.h),
                  Text(
                    'Height (cm)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Color(0xff444444),
                    ),
                  ),

                  InkWell(
                    // 點擊整個容器時觸發 bottomSheet
                    onTap: () {
                      // 在打開 bottomSheet 之前先獲取 controller 引用
                      final infoController = Get.find<InformationController>();

                      Get.bottomSheet(
                        // bottomSheet 的主容器
                        Container(
                          // 設定 bottomSheet 高度為螢幕高度的 60%，避免無限高度導致佈局崩潰
                          height:
                              MediaQuery.of(Get.context!).size.height * 0.60,
                          width: double.infinity,

                          // 內部左右留白
                          padding: EdgeInsets.symmetric(horizontal: 12.w),

                          // 白色背景 + 頂部圓角
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24.h),
                            ),
                          ),

                          child: Column(
                            // 使用 min 避免 Column 在垂直方向無限擴張
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // 頂部間距
                              Gap(32.h),
                               Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Weight',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Color(0xff333333),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20.w),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff3262FF),
                                        borderRadius: BorderRadius.circular(
                                          24.h,
                                        ),
                                        border: Border.all(
                                          color: Color(0xff3262FF),
                                        ),
                                      ),
                                      child: Text(
                                        'cm',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20.w),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 30.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          24.h,
                                        ),
                                        border: Border.all(
                                          color: Color(0xff3262FF),
                                        ),
                                      ),
                                      child: Text(
                                        'ft',
                                        style: TextStyle(
                                          color: Color(0xff3262FF),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(17.h),
                              Container(
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xffF5F6FA),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24.w),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Your height',
                                  ),
                                ),
                              ),
                             

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(),
                              ),

                              Gap(32.h),

                              //插入身高尺子 - 可拖动滑块
                              // ── 尺子区域 ──
                              RulerWidget(
                                onVerticalDragUpdate:
                                    controller.onVerticalDragUpdate,
                                onVerticalDragEnd: controller.onVerticalDragEnd,
                                visibleHeight: controller.visibleHeight,
                                offset: controller.offset,
                                targetOffset: controller.targetOffset,
                                tickSpacing: controller.tickSpacing,
                                minValue: controller.minValue,
                                maxValue: controller.maxValue,
                                unit: 'cm',
                              ),

                              Gap(24.h),

                              // 確認按鈕（置中）
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 40.w,vertical: 10.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24.h),
                                        border: Border.all(
                                          color: Color(0xff3c72ff),
                                        )
                                      ),
                                      child: Text('Cancel',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w500,color: Color(0xff3c72ff)),),
                                    ),
                                    Gap(20.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 50.w,vertical: 10.h),
                                      decoration: BoxDecoration(
                                        color: Color(0xff3c72ff),
                                        borderRadius: BorderRadius.circular(24.h),
                                        border: Border.all(
                                          color: Color(0xff3c72ff),
                                        )
                                      ),
                                      child: Text('Next',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w500,color: Colors.white),),
                                    ),
                                    

                                  ],
                                ),
                              ),

                              // 底部額外安全間距，避免按鈕太貼底
                              Gap(15.h),
                            ],
                          ),
                        ),

                        // 重要參數：允許自訂高度的 bottomSheet
                        isScrollControlled: true,

                        // 背景透明，讓頂部圓角更自然顯示
                        backgroundColor: Colors.transparent,
                      );
                    },

                    // 未點擊時顯示的容器（目前身高預覽）
                    child: Container(
                      // 內部上下左右留白
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),

                      // 淺灰色背景 + 圓角
                      decoration: BoxDecoration(
                        color: Color(0xffF5F6FA),
                        borderRadius: BorderRadius.circular(24.h),
                      ),

                      child: Row(
                        // 左右對齊：左邊顯示身高，右邊顯示箭頭
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          // 目前選擇的身高（這裡寫死 170 cm，建議改用 Obx 從 controller 取值）
                          Text('170 cm', style: TextStyle(fontSize: 16.sp)),

                          // 右側箭頭圖示，表示可點擊編輯
                          Icon(Icons.arrow_forward_ios, size: 16.sp),
                        ],
                      ),
                    ),
                  ),

                  Gap(16.h),
                  Text(
                    'weight (cm)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Color(0xff444444),
                    ),
                  ),

                  InkWell(
                    // 點擊整個容器時觸發 bottomSheet
                    onTap: () {
                      // 在打開 bottomSheet 之前先獲取 controller 引用
                      final infoController = Get.find<InformationController>();

                      Get.bottomSheet(
                        // bottomSheet 的主容器
                        Container(
                          // 設定 bottomSheet 高度為螢幕高度的 60%，避免無限高度導致佈局崩潰
                          height:
                              MediaQuery.of(Get.context!).size.height * 0.60,
                          width: double.infinity,

                          // 內部左右留白
                          padding: EdgeInsets.symmetric(horizontal: 12.w),

                          // 白色背景 + 頂部圓角
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24.h),
                            ),
                          ),

                          child: Column(
                            // 使用 min 避免 Column 在垂直方向無限擴張
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // 頂部間距
                              Gap(32.h),

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Weight',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Color(0xff333333),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20.w),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff3262FF),
                                        borderRadius: BorderRadius.circular(
                                          24.h,
                                        ),
                                        border: Border.all(
                                          color: Color(0xff3262FF),
                                        ),
                                      ),
                                      child: Text(
                                        'lb',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20.w),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 30.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          24.h,
                                        ),
                                        border: Border.all(
                                          color: Color(0xff3262FF),
                                        ),
                                      ),
                                      child: Text(
                                        'kg',
                                        style: TextStyle(
                                          color: Color(0xff3262FF),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                             
                              Gap(17.h),
                              Container(
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xffF5F6FA),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24.w),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Your weight',
                                  ),
                                ),
                              ),

                              Gap(32.h),

                              //插入身高尺子 - 可拖动滑块
                              // ── 尺子区域 ──
                              RulerWidget(
                                onVerticalDragUpdate:
                                    controller.onVerticalDragUpdate,
                                onVerticalDragEnd: controller.onVerticalDragEnd,
                                visibleHeight: controller.visibleHeight,
                                offset: controller.offset,
                                targetOffset: controller.targetOffset,
                                tickSpacing: controller.tickSpacing,
                                minValue: controller.weightMinValue,
                                maxValue: controller.weightMaxValue,
                                unit: 'kg',
                              ),

                              Gap(24.h),

                               // 確認按鈕（置中）
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 40.w,vertical: 10.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24.h),
                                        border: Border.all(
                                          color: Color(0xff3c72ff),
                                        )
                                      ),
                                      child: Text('Cancel',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w500,color: Color(0xff3c72ff)),),
                                    ),
                                    Gap(20.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 50.w,vertical: 10.h),
                                      decoration: BoxDecoration(
                                        color: Color(0xff3c72ff),
                                        borderRadius: BorderRadius.circular(24.h),
                                        border: Border.all(
                                          color: Color(0xff3c72ff),
                                        )
                                      ),
                                      child: Text('Next',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w500,color: Colors.white),),
                                    ),
                                    

                                  ],
                                ),
                              ),

                              // 底部額外安全間距，避免按鈕太貼底
                              Gap(15.h),
                            ],
                          ),
                        ),

                        // 重要參數：允許自訂高度的 bottomSheet
                        isScrollControlled: true,

                        // 背景透明，讓頂部圓角更自然顯示
                        backgroundColor: Colors.transparent,
                      );
                    },

                    // 未點擊時顯示的容器（目前身高預覽）
                    child: Container(
                      // 內部上下左右留白
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),

                      // 淺灰色背景 + 圓角
                      decoration: BoxDecoration(
                        color: Color(0xffF5F6FA),
                        borderRadius: BorderRadius.circular(24.h),
                      ),

                      child: Row(
                        // 左右對齊：左邊顯示身高，右邊顯示箭頭
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          // 目前選擇的身高（這裡寫死 170 cm，建議改用 Obx 從 controller 取值）
                          Text('170 cm', style: TextStyle(fontSize: 16.sp)),

                          // 右側箭頭圖示，表示可點擊編輯
                          Icon(Icons.arrow_forward_ios, size: 16.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
