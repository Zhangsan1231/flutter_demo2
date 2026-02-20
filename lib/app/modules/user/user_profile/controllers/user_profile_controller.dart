
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/data/repository/default_repository_impl.dart';
import 'package:get/get.dart';

class UserProfileController extends BaseController {
  final DefaultRepositoryImpl _repositoryImpl = DefaultRepositoryImpl();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final selectedBirthday = Rx<DateTime?>(null);

  // Rx<File?> selectedImage = Rx<File?>(null); // 用于 UI 显示


  // Future<void> savePhoto() async {
  //   if (selectedImage.value == null) {
  //     logger.w('请先上传头像');
  //     return;
  //   }
  //   //开始上传头像
  //   try {
  //     final File fileToUpload = selectedImage.value!;
  //     final imageUrl = await _repositoryImpl.uploadImage(fileToUpload);
  //     if (imageUrl == null) {
  //       logger.d('图像上传失败，服务器返回空url');
  //       Get.snackbar('图像上传失败', '图片上传失败');
  //       return;
  //     }
  //     logger.d('图片上传成功 url :${imageUrl}');
  //     //图片上传成功后用 patchinfo更新用户信息
  //     final success = await _repositoryImpl.patchInfo({'photo': imageUrl});
  //     if (!success) {
  //       logger.d('更新用户信息失败');
  //       Get.snackbar('用户信息更新失败', '图片上传失败');
  //     }
  //     logger.d('更新用户信息成功');

  //     //更新本地用户信息
  //     final currentUser = SecureStorageService().getUserInfo();
  //     if(currentUser !=null){
  //       currentUser.photo = imageUrl;
  //       SecureStorageService().setUserInfo(currentUser);
  //       logger.d('本地用户已经更新');
  //       Get.toNamed(Routes.USER);
  //       Get.find<UserController>().refreshAvatar();  // 或任何刷新方

  //     }
  //   } catch (e) {}
  // }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

}