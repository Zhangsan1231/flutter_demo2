import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/ai_ring_controller.dart';

class AiRingView extends BaseViews<AiRingController> {
  AiRingView({super.key}) : super(bgColor: Color(0xfffafafa));
  @override
  Widget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        
        children: [
           Gap(80.h),
          Row(
            children: [
                                 

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // Container()
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cardText('Blood oxygen'),
                        // Spacer(),
                        imageAsset(Assets.images.bloodOxygen.path),
                      ],
                    ),
                    // Spacer(),
                    // imageAsset(Assets.images.bloodOxygen.path,)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget cardText(String label) {
  return Text(
    '${label}',
    style: TextStyle(
      color: Color(0xff333333),
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
    ),
  );
}

Widget imageAsset(String path) {
  return Image.asset(path, width: 16.w, height: 16.h);
}
