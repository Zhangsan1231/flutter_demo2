import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/data/repository/auth_repository_impl.dart';
import 'package:flutter_demo2/app/data/repository/default_repository_impl.dart';
import 'package:flutter_demo2/app/modules/user/controllers/user_controller.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UserProfileController extends BaseController {
  final DefaultRepositoryImpl _repositoryImpl = DefaultRepositoryImpl();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final selectedBirthday = Rx<DateTime?>(null);

  Rx<File?> selectedImage = Rx<File?>(null); // 用于 UI 显示

  //修改用户头像 本地显示
  Future<void> uploadPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      ); //从图库中选择图像
      if (pickedFile == null) {
        logger.d('用户取消选择图片');
        return;
      }
      // 打印临时路径（调试用）
      logger.d('临时路径: ${pickedFile.path}');

      // 获取 App 文档目录（永久保存位置）
      final directory = await getApplicationDocumentsDirectory();

      // 生成唯一文件名（防止覆盖）
      final String fileName =
          'user_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String permanentPath = '${directory.path}/$fileName';

      // 复制文件到永久目录
      final File permanentFile = await File(
        pickedFile.path,
      ).copy(permanentPath);
      // 保存永久路径到 SecureStorage
      await SecureStorageService().setUserPhoto(permanentPath);

      logger.d('已保存永久路径: $permanentPath');
      logger.d('读取验证: ${await SecureStorageService().getUserPhoto()}');

      // 更新 Rx 变量，让 UI 立即显示
      selectedImage.value = permanentFile;
    } catch (e) {
      logger.e('保存图片失败: $e');
    }
  }

  Future<void> savePhoto() async {
    if (selectedImage.value == null) {
      logger.w('请先上传头像');
      return;
    }
    //开始上传头像
    try {
      final File fileToUpload = selectedImage.value!;
      final imageUrl = await _repositoryImpl.uploadImage(fileToUpload);
      if (imageUrl == null) {
        logger.d('图像上传失败，服务器返回空url');
        Get.snackbar('图像上传失败', '图片上传失败');
        return;
      }
      logger.d('图片上传成功 url :${imageUrl}');
      //图片上传成功后用 patchinfo更新用户信息
      final success = await _repositoryImpl.patchInfo({'photo': imageUrl});
      if (!success) {
        logger.d('更新用户信息失败');
        Get.snackbar('用户信息更新失败', '图片上传失败');
      }
      logger.d('更新用户信息成功');

      //更新本地用户信息
      final currentUser = SecureStorageService().getUserInfo();
      if(currentUser !=null){
        currentUser.photo = imageUrl;
        SecureStorageService().setUserInfo(currentUser);
        logger.d('本地用户已经更新');
        Get.toNamed(Routes.USER);
        Get.find<UserController>().refreshAvatar();  // 或任何刷新方

      }
    } catch (e) {}
  }


// 选择图片的方法
Future<void> pickImage() async {
  final XFile? pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery, // 指定从相册选择
  );
  if (pickedFile == null) return; // 用户取消选择
  final String imagePath = pickedFile.path;
  // 选择成功后，调用裁剪方法
  cropSelectedImage(imagePath);
}

  // 裁剪图片的方法
Future<void> cropSelectedImage(String imagePath) async {
  final CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: imagePath,
    // 常用参数（强烈建议配置）
    // 强制宽高比 1:1（头像最常用）
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
       
    // 配置不同平台的 UI 样式
    uiSettings: [
      
      AndroidUiSettings(
        
        
        toolbarTitle: '裁剪图片',
        toolbarColor: Colors.blue, // 工具栏颜色
        toolbarWidgetColor: Colors.white, // 工具栏文字颜色
        aspectRatioPresets: [
          CropAspectRatioPreset.square, // 1:1 比例
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
        ],
        initAspectRatio: CropAspectRatioPreset.original, // 初始比例
        lockAspectRatio: false, // 是否锁定比例
      ),
     IOSUiSettings(
        title: '裁剪图片',
        resetAspectRatioEnabled: true,
        // iOS 也支持（新版本中）
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.ratio3x2,
        //   CropAspectRatioPreset.ratio4x3,
        //   CropAspectRatioPreset.ratio16x9,
        //   CropAspectRatioPreset.original,
        // ],
        
        aspectRatioLockEnabled: false,
      ),
    ],
  );

  if (croppedFile != null) {
    // 裁剪成功，获取裁剪后的图片路径
    final String croppedPath = croppedFile.path;
    print('裁剪完成，路径：$croppedPath');
    // 后续可将图片显示在页面上，或上传到服务器
  }
}

}
