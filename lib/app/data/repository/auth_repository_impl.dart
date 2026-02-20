import 'dart:math';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:authing_sdk/client.dart';
import 'package:authing_sdk/result.dart';
import 'package:authing_sdk/user.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo2/app/core/base/base_repository.dart';
import 'package:flutter_demo2/app/core/model/region_unit.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';
import 'package:flutter_demo2/app/data/model/user_model.dart';
import 'package:flutter_demo2/app/data/repository/auth_repository.dart';
import 'package:flutter_demo2/app/data/repository/default_repository_impl.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  @override
  Future<Map<String, dynamic>> getUserDetails() {
    // TODO: implement getUserDetails
    throw UnimplementedError();
  }

  @override
  Future<String> googleLogin(String username, String password) {
    // TODO: implement googleLogin
    throw UnimplementedError();
  }

  @override
  Future<String> loginEmailAndPassword(String username, String password) async {
    var test = storage.getRegion();
    logger.d('test$test');
    if (storage.getRegion() == RegionUnit.zh) {
      logger.d(password);

      AuthResult response = await AuthClient.loginByAccount(username, password);

      // logger.d("当前登录Response：${response.user?.token}");
      // logger.d(response);
      // logger.d(response.code);
      final user = response.user;
      // SecureStorageService().setUserInfo(user as UserModel);
      logger.d(
        'SecureStorageService().getUserInfo()?.name; :${SecureStorageService().getUserInfo()?.name}',
      );
      if (user != null) {
        storage.setIdToken(user.token);
        logger.d('user.token111111111 ${user.token}');
        if (user.accessToken != null && user.accessToken!.isNotEmpty) {
          storage.setAccessToken(user.accessToken!);
          logger.d('Access Token 保存成功: ${user.accessToken}');
        } else {
          logger.e('登录成功但 accessToken 为 null 或空，无法保存');
          // 可选：抛异常或显示提示
          // Get.snackbar('登录异常', '服务器未返回有效的 token');
        }
        storage.setUserId(user.id);
        print('登录成功登录成功登录成功');
      }
      return '登录成功';
    } else if (storage.getRegion() == RegionUnit.en) {
      final auth0 = Auth0(AppValues.domain, AppValues.clientId);
      final credentials = await auth0.api.login(
        usernameOrEmail: username,
        password: password,
        connectionOrRealm: AppValues.connection,
      );
      if (credentials != null) {
        if (credentials.idToken != null) {
          logger.d('credentials.idToken:${credentials.idToken}');
          storage.setIdToken(credentials.idToken);
          logger.d('idtoken保存成功');
        }
        if (credentials.accessToken != null) {
          logger.d('credentials.accessToken:${credentials.accessToken}');
          storage.setAccessToken(credentials.accessToken);
          logger.d('Accestoken保存成功');
        }
      }

      return '登录成功';
    } else {
      return '登录失败';
    }
  }

  @override
  Future<void> logout() async {
    AuthResult result = await AuthClient.logout();
    var code = result.code;
    logger.d('code==========${code}');
  }

  @override
  Future<String> wxLogin(String username, String password) {
    // TODO: implement wxLogin
    throw UnimplementedError();
  }

  @override
  Future<User> registerByEmail(String email, String password) async {
    AuthResult result = await AuthClient.registerByEmail(email, password);
    User? user = result.user;
    // logger.d(user?.email);
    // logger.d(user?.);
    return user!;
  }

  @override
  Future<bool> ensureUserInitialized() async {
    try {
      try {
        //1.从后端获取用户数据
        UserModel? userModel = await DefaultRepositoryImpl().getInfo();
        //不为空 则存入用户数据
        if (userModel != null) {
          storage.setUserInfo(userModel);
          logger.d('获取用户信息成功 111111111');
          final user = storage.getUserInfo();
          logger.d('测试user.name${user?.name}');
          return true;
        }
      } catch (e) {
        logger.w('初次获取用户信息失败，尝试创建：$e');
      }
      //2.获取失败 尝试创建用户
      // logger.d('尝试创建默认用户数据');
      await DefaultRepositoryImpl().postInfo();
      //3.创建后再次获取数据
      UserModel? userModel = await DefaultRepositoryImpl().getInfo();
      if (userModel != null) {
        storage.setUserInfo(userModel);
        logger.d('用户数据初始化成功');
        return true;
      } else {
        logger.d('创建用户后再次获取失败');
        return false;
      }
    } catch (e) {
      logger.e('用户初始化失败:$e');
      return false;
    }
  }

  @override
  Future<bool> uploadUserProfile(Map<String, Object> map) async {
    return await DefaultRepositoryImpl().patchInfo(map);
  }

  //authing通过邮箱忘记密码
  @override
  Future<bool> forgetEmail(String email) async {
    try {
      AuthResult result = await AuthClient.sendEmail(email, 'RESET_PASSWORD');
      logger.d('邮箱：${email}');
      logger.d('result.code = ${result.code}');
      if (result.code == 200) {
        print('邮箱发送成功');
        return true;
      }
      print('邮箱发送失败');

      return false;
    } catch (e) {
      print('邮箱发送失败');

      return false;
    }
  }
  
  @override
  Future<int> resetPasswordByEmailCode(String email, String code, String password) async {
    try {
      AuthResult result = await AuthClient.resetPasswordByEmailCode(email,code,password);
      return result.code;
    } catch (e) {
      return 0;
    }
  }
  
  @override
  Future<void> resetPassword(String email) async {
   final auth0 = Auth0(AppValues.domain,AppValues.clientId);

  try {
     auth0.api.resetPassword(email: email, connection: AppValues.connection);
     print('auth0 邮件发送成功');
  } catch (e) {
         print('auth0 邮件发送失败');

  }
  }
  
 
}
