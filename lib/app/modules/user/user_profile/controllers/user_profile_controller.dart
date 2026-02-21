import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/data/repository/default_repository_impl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProfileController extends BaseController {
  final DefaultRepositoryImpl _repositoryImpl = DefaultRepositoryImpl();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final selectedBirthday = Rx<DateTime?>(null);

  // 当前选择的图片（用于 UI 实时预览）
  Rx<File?> selectedImage = Rx<File?>(null);

//用户显示加载框
  RxBool uploadResult = false.obs;
  // 新增：上传进度（0.0 ~ 1.0）
  final RxDouble uploadProgress = 0.0.obs;

  // 新增：是否正在上传
  final RxBool isUploading = false.obs;


/// 上传用户头像 + 屏幕中间弹出进度条
Future<void> uploadAvatar() async {
  final file = selectedImage.value;
  if (file == null) {
    Get.snackbar('提示', '请先选择图片');
    return;
  }

  isUploading.value = true;
  uploadProgress.value = 0.0;

  // 显示居中进度弹窗
  Get.dialog(
    Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 220.w,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    value: uploadProgress.value,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                  Gap(20.h),
                  Text(
                    '正在上传头像...',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                  Gap(8.h),
                  Text(
                    '${(uploadProgress.value * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              )),
        ),
      ),
    ),
    barrierDismissible: false,
  );

  try {
    final imageUrl = await DefaultRepositoryImpl().uploadImage(
      file,
      onProgress: (progress) {
        uploadProgress.value = progress;
      },
    );

    if (imageUrl != null) {
      await DefaultRepositoryImpl().patchInfo({'photo': imageUrl});
      Get.snackbar('成功', '头像上传成功');
      selectedImage.value = null;
    } else {
      Get.snackbar('失败', '头像上传失败');
    }
  } catch (e) {
    Get.snackbar('错误', '上传失败，请重试');
  } finally {
    isUploading.value = false;

    // 【只关闭弹窗，不返回上一页】
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      if (Get.isDialogOpen == true) {
        Navigator.of(Get.overlayContext!).pop();   // 最可靠的关闭方式
      }
    } catch (e) {
      Get.back(closeOverlays: true);   // 兜底方案
    }

    uploadProgress.value = 0.0;
  }
}

/// 使用相机拍照 + 立即裁剪
Future<void> takePhoto() async {
  print('开始调用 takePhoto 方法');

  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 85,
  );

  print('pickedFile ======= ${pickedFile}');

  if (pickedFile == null) {
    print('用户取消了拍照');
    return;
  }

  print('开始执行裁剪...');
  final croppedFile = await _cropImage(File(pickedFile.path));

  if (croppedFile != null) {
    print('裁剪成功，更新 selectedImage');
    selectedImage.value = croppedFile;
    Get.snackbar('拍照成功', '头像已裁剪完成');
  } else {
    print('裁剪失败或用户取消，selectedImage 未更新');
  }
}
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
    if (pickedFile == null) return;

    // 选择后立即进行裁剪
    final croppedFile = await _cropImage(File(pickedFile.path));

    if (croppedFile != null) {
      selectedImage.value = croppedFile;
      Get.snackbar('裁剪成功', '头像已裁剪完成');
    }
  
  }

/// 图片裁剪方法（正方形裁剪，适合头像）
Future<File?> _cropImage(File imageFile) async {
  print('开始裁剪图片，原始路径: ${imageFile.path}');

  try {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '裁剪头像',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: '裁剪头像',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 90,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (croppedFile != null) {
      print('裁剪成功！裁剪后路径: ${croppedFile.path}');
      return File(croppedFile.path);
    } else {
      print('用户取消了裁剪或裁剪失败，返回 null');
      return null;
    }
  } catch (e, stack) {
    print('裁剪过程发生异常: $e');
    print('异常堆栈: $stack');
    return null;
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