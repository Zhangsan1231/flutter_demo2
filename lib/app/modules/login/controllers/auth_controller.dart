import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // 替换成你的真实值
  static const String domain = 'https://ineck.auth0.com';
  static const String clientId = 'n3MTVDRdyq9xl2riKm5cWW2wxWcGhnLA';
  static const String scheme = 'auth0.$clientId';  // 回调 scheme

  final auth0 = Auth0(domain, clientId);

  Rx<UserProfile?> user = Rx<UserProfile?>(null);
  RxBool isAuthenticated = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // checkSession();
  }

  // // 检查已有登录会话
  // Future<void> checkSession() async {
  //   try {
  //     final credentials = await auth0.credentials();
  //     user.value = credentials.user;
  //     isAuthenticated.value = true;
  //     print('已有会话，用户: ${user.value?.name}');
  //   } catch (e) {
  //     print('无有效会话: $e');
  //     isAuthenticated.value = false;
  //   }
  // }

  // 登录（弹出浏览器登录页）
  Future<void> login() async {
    try {
      isLoading.value = true;
      final credentials = await auth0
          .webAuthentication(scheme: scheme)
          .login(useHTTPS: true);  // 推荐开启 HTTPS

      user.value = credentials.user;
      isAuthenticated.value = true;

      print('登录成功，用户: ${user.value?.name}');
      print('Access Token: ${credentials.accessToken}');
      print('ID Token: ${credentials.idToken}');

      // 保存 token 到安全存储
      // await SecureStorageService.instance.setString('access_token', credentials.accessToken);

      Get.offAllNamed('/home'); // 跳转首页
    } catch (e) {
      isLoading.value = false;
      print('登录失败: $e');
      Get.snackbar('登录失败', e.toString());
    }
  }

  // 登出
  Future<void> logout() async {
    try {
      await auth0.webAuthentication(scheme: scheme).logout(useHTTPS: true);
      user.value = null;
      isAuthenticated.value = false;
      Get.offAllNamed('/login');
      print('已登出');
    } catch (e) {
      print('登出失败: $e');
    }
  }
}