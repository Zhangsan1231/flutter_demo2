import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/modules/user/controllers/user_controller.dart';
import 'package:flutter_demo2/app/modules/user/widget/custom_image.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/blue_user_controller.dart';

class BlueUserView extends BaseViews<BlueUserController> {
  // BlueUserView({super.key});

  @override
  Widget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.h),
      width: double.infinity,
      
      child: Column(
        children: [
          Gap(50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Obx(() {
            final photo = controller.photo.value;
            final name = SecureStorageService().getUserInfo()?.name;
            if(photo == null){
              // return Image.asset(Assets.images.userPhoto.path,width: 58.w,height: 58.h,);
              return Row(
                children: [
                  Image.asset(Assets.images.userPhoto.path,width: 58.w,height: 58.h,),
                  Text('$name'),
                ],
              );
            }
            return Row(
                children: [
                  CustomCachedNetworkImage(imageUrl: photo,width: 58.w,height: 58.h,),
                  Text('$name'),
                ],
              );
            // return CustomCachedNetworkImage(imageUrl: photo,width: 58.w,height: 58.h,);
          }),
          
          // Text('$'),
            ],
          ),
          Gap(20.h),
          InkWell(
            onTap: (){
              Get.toNamed(Routes.MY_BLUETOOTH);
            },
            child: Container(
            decoration: BoxDecoration(
              color: Colors.grey
            ),
            child: Row(
              children: [
                Image.asset(Assets.images.userBluetooth.path,width: 50.w,height: 50.h,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bluetooth'),
                    Text('2 devices have been connected.'),
                  ],
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          )
          ,
          ),
          InkWell(
            onTap: () => Get.toNamed(Routes.HOME),
            child: Container(
            decoration: BoxDecoration(
              color: Colors.amber
            ),
            padding: EdgeInsets.symmetric(horizontal: 50.w,vertical: 20.h),
            child: Text('goHome'),),)
        ],
      ),
    );
  }
}
