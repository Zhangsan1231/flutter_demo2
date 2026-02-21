import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/data/repository/default_repository_impl.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProfileController extends BaseController {
  final DefaultRepositoryImpl _repositoryImpl = DefaultRepositoryImpl();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final selectedBirthday = Rx<DateTime?>(null);

  // 当前选择的图片（用于 UI 实时预览）
  Rx<File?> selectedImage = Rx<File?>(null);

  // ==================== 权限相关方法 ====================




  // ==================== 图片选择方法 ====================

  // 从相册选择单张图片
  Future<void> pickImageFromGallery({bool crop = false}) async {
    // if (!await _requestGalleryPermission()) {
    //   return; // 已在权限方法中处理弹窗
    // }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // 压缩质量
    );

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      Get.snackbar('选择成功', '已选择图片');
    }
  }

 

  // ==================== 其他方法 ====================

  @override
  void onInit() {
    super.onInit();
    // 可以在这里做初始化操作
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    selectedImage.value?.delete(); // 可选：清理临时文件
    super.onClose();
  }
}