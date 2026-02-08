import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginBanner extends StatelessWidget {
  const LoginBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        Gap(40.h),
        Image.asset(Assets.images.aih.path,height: 62.h,fit: BoxFit.fitHeight,),
        Gap(12.h),
        Text("Hello, welcome to AIH.",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.white),)
      ],
    );
  }
}