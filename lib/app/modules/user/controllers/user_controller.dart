import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/data/model/user_model.dart';
import 'package:flutter_demo2/app/data/repository/auth_repository_impl.dart';
import 'package:flutter_demo2/app/data/repository/default_repository_impl.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class UserController extends BaseController {
  RxString photo = ''.obs;
  RxString avatarPath = ''.obs;
  final storage = SecureStorageService();
  //获取用户头像
  Future<void> userInfo() async {
    UserModel? userModel = await DefaultRepositoryImpl().getInfo();
    logger.d('userModel?.phone.toString() ${userModel?.phone.toString()}');
  }

  //注销
  Future<void> logout() async {
    AuthRepositoryImpl().logout();
    SecureStorageService().deleteAll();
    Get.toNamed(Routes.LOGIN);
  }

  //加载头像
  Future<void> loadingImage() async {
    final userPhoto = storage.getUserInfo()?.photo;
    final photo = storage.getUserPhoto();
    if (userPhoto != null && userPhoto.isNotEmpty) {
      final imageUrl = await saveImageToAppDir(userPhoto);
      if (imageUrl != null && imageUrl.isNotEmpty) {
        avatarPath.value = imageUrl!;
      }
    }else{
       if (photo != null && photo.isNotEmpty) {
        avatarPath.value = photo;
       }
    }
  }

  //将图像保存到本地
  Future<String?> saveImageToAppDir(String imageUrl) async {
    UserModel? userModel = await DefaultRepositoryImpl().getInfo();

    if (imageUrl == null || imageUrl!.isEmpty) {
      // 没有头像：显示默认头像、占位图、让用户上传等
      // 比如：
      // _avatarUrl = 'assets/default_avatar.png';
      logger.d('头像为空');
    } else {
      // 有头像  进行本地存储 我这是从网络上请求的图片 如何将它保存永久路径
      // _avatarUrl = userModel.photo!;
      //首先下载图片
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode != 200) {
          logger.d('下载失败');
          return '';
        }
        // 2. 获取应用文档目录（永久保存，不会轻易被系统清理）
        final directory = await getApplicationDocumentsDirectory();
        // 或者用 getTemporaryDirectory() → 临时目录（可能被清理）

        // 3. 生成文件名（避免覆盖）
        final String ext = imageUrl!.split('.').last.split('?').first; // 尽量取后缀
        final String fileName =
            'IMG_${DateTime.now().millisecondsSinceEpoch}.$ext';
        final File file = File('${directory.path}/$fileName');

        // 4. 写入文件
        await file.writeAsBytes(response.bodyBytes);
        print('图片已保存到: ${file.path}');
        return file.path;
      } catch (e) {
        print('保存失败: $e');
        return '';
      }
      return '';
      //从网络中下载头像
    }
  }

  final RxString userPhoto = ''.obs;           // 頭像 url 做成 Rx
  final RxBool isLoadingAvatar = false.obs;    // 可選 loading 狀態

  @override
  void onInit() {
    super.onInit();
    refreshAvatar();
  }

  @override
  void onReady() {
    super.onReady();
    // 這裡每次頁面顯示時都會執行（當使用 Get.to / Get.off 等導航）
    refreshAvatar();
  }

  Future<void> refreshAvatar() async {
    isLoadingAvatar.value = true;
    try {
      final user = await SecureStorageService().getUserInfo();
      final newPhoto = user?.photo ?? '';

      if (newPhoto != userPhoto.value) {
        userPhoto.value = newPhoto;  // 變化才觸發 Obx 重建
      }

      // 如果你想強制重新下載（忽略舊緩存），可以清空舊檔案或改用新邏輯
      // 或者直接依賴 CustomCachedNetworkImage 自己的 didUpdateWidget
    } catch (e) {
      print('刷新頭像失敗: $e');
    } finally {
      isLoadingAvatar.value = false;
    }
  }
}
