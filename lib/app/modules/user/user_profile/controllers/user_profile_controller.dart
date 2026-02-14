import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileController extends BaseController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final selectedBirthday = Rx<DateTime?>(null);

Rx<File?> selectedImage = Rx<File?>(null);  // 用于 UI 显示

  //上传用户头像
  Future<void> uploadPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedFile =  await picker.pickImage(source: ImageSource.gallery); //从图库中选择图像
      if(pickedFile != null){
        // logger.d('pickedFile.path: ${pickedFile.path}');
        SecureStorageService().setUserPhoto(pickedFile.path);
        logger.d("SecureStorageService().setUserPhoto : ${SecureStorageService().getUserPhoto()}");

selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      
    }
  }
}
