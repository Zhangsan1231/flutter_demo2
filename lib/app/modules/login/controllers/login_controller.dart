import 'package:auth0_flutter/auth0_flutter.dart';
// import 'package:authing_sdk/client.dart';
// import 'package:authing_sdk/result.dart';
// import 'package:authing_sdk/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_controller.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';
import 'package:flutter_demo2/app/data/repository/auth_repository_impl.dart';
import 'package:flutter_demo2/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl();
  SecureStorageService storage = SecureStorageService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // / 方便获取值的方法（可选）
  String get email => emailController.text.trim();
  String get password => passwordController.text.trim();
  // AuthRepositoryImpl authImpl = AuthRepositoryImpl();

  // // 替换成你的真实值
  // static const String domain = 'ineck.auth0.com';

  // // static const String domain = 'dev-mca27oqqcbe8vq7u.us.auth0.com';
  // // static const String clientId = 'bPZXfsSgqlAvm4naId6i9o2m6JyRwz8C';
  // static const String clientId = 'n3MTVDRdyq9xl2riKm5cWW2wxWcGhnLA';
  // static const String scheme = 'auth0.$clientId';  // 回调 scheme

  final auth0 = Auth0(AppValues.domain, AppValues.clientId);

  Rx<UserProfile?> user = Rx<UserProfile?>(null);
  RxBool isAuthenticated = false.obs;
  RxBool isLoading = false.obs;
  // 登录（弹出浏览器登录页）
  Future<void> auth0Login() async {
    try {
      isLoading.value = true;
      final credentials = await auth0.api.login(usernameOrEmail: email, password: password, connectionOrRealm: 'Username-Password-Authentication');
      // final credentials = await auth0
      //     .webAuthentication(scheme: scheme)
      //     .login(
      //     useHTTPS: false,  // 推荐 true，但需配置 Associated Domains
      //     // 可选：指定初始显示注册页
      //     parameters: {'screen_hint': 'signup'},  // ← 关键！显示注册页
      //   );
      user.value = credentials.user;
      isAuthenticated.value = true;

      print('登录成功，用户: ${user.value?.name}');
      print('Access Token: ${credentials.accessToken}');
      print('ID Token: ${credentials.idToken}');

      // 保存 token 到安全存储
      // await SecureStorageService.instance.setString('access_token', credentials.accessToken);

      // Get.offAllNamed('/home'); // 跳转首页
    } catch (e) {
      isLoading.value = false;
      print('登录失败: $e');
      Get.snackbar('登录失败', e.toString());
    }
  }

  //登录
  Future<void> Login() async {
    String result = await authRepositoryImpl.loginEmailAndPassword(
      email,
      password,
    );
    logger.d('11111111111111$result');
    if (result == '登录成功') {
      //登录成功后确保用户数据初始化
      bool userInitSuccess = await authRepositoryImpl.ensureUserInitialized();
      logger.d('1222222222222222$userInitSuccess');
      if (userInitSuccess) {
        final user = storage.getUserInfo();
      
        logger.d('user.name = ${user?.name}');
        logger.d('userBithdate:${user?.birthdate}');
        if (user?.name == 'defualtName'){
          Get.toNamed(Routes.INFORMATION);
        }else{
          Get.toNamed(Routes.BLUE_USER);
        }

        // logger.d('storage.getUserInfo() ================${storage.getUserInfo()?.name}');
        // if(storage.getUserInfo()?.name ==null ) Get.toNamed(Routes.INFORMATION);
        // logger.d("userInitSuccess:$userInitSuccess");
        //展示弹窗
        // Get.offNamed(Routes.NAVIGATION);
      } else {
        logger.d('未查询到数据');
      }
    } else {
      logger.d('登录失败');
    }
    //  final emailValue = email;
    //   final passwordValue = password;

    //   print('邮箱: $emailValue');
    //   print('密码: $passwordValue');
    //   AuthResult result = await AuthClient.loginByAccount(emailValue,passwordValue);
    //   User? user = result.user; // user info
    //   logger.d(result.code);
    //   logger.d(user?.token);
    // if(user!.token.isNotEmpty){
    //   SecureStorageService.instance.setAccessToken(accessToken)
    // }
  }

  //获取账号
  void accountText() {}
}
