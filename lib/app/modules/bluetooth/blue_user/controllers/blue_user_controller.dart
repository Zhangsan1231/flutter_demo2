import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/data/model/user_model.dart';
import 'package:get/get.dart';

class BlueUserController extends BaseController {
 // 当前用户信息（全局 Rx）
  final currentUser = Rx<UserModel?>(null);

  final isLoadingAvatar = false.obs;
  final photo = Rx<String?>(null);  // 头像 URL 或本地路径

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();  // 每次初始化（包括热重载）都重新加载
  }

  Future<void> loadUserFromStorage() async {
    try {
      final user = await SecureStorageService().getUserInfo();
      if (user != null) {
        currentUser.value = user;
        photo.value = user.photo;  // 更新头像 URL
        print('从存储加载用户名: ${user.name}');
      } else {
        print('本地无用户信息');
      }
    } catch (e) {
      print('加载用户信息失败: $e');
    }
  }

  // 登录成功后调用（或更新时调用）
  void updateUser(UserModel user) {
    SecureStorageService().setUserInfo(user);
    currentUser.value = user;
    photo.value = user.photo;
  }
}