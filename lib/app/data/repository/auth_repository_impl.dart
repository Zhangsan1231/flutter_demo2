import 'package:authing_sdk/client.dart';
import 'package:authing_sdk/result.dart';
import 'package:authing_sdk/user.dart';
import 'package:flutter_demo2/app/core/base/base_repository.dart';
import 'package:flutter_demo2/app/core/model/region_unit.dart';
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
    if (storage.getRegion() == RegionUnit.zh) {
      AuthResult response = await AuthClient.loginByAccount(username, password);
      // logger.d("当前登录Response：${response.user?.token}");
      // logger.d(response);
      // logger.d(response.code);
      final user = response.user;
      if (user != null) {
        storage.setIdToken(user.token);
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
    } else {
      return '登录失败';
    }
    // TODO: implement loginEmailAndPassword
  }

  @override
  Future<void> logoutl() {
    // TODO: implement logoutl
    throw UnimplementedError();
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
        //1.从本地获取用户数据
        UserModel? userModel = await DefaultRepositoryImpl().getInfo();
        if (userModel != null) {
          storage.setUserInfo(userModel);
          return true;
        }
      } catch (e) {
        logger.w('初次获取用户信息失败，尝试创建：$e');
      }
      //2.获取失败 尝试创建用户
      // logger.d('尝试创建默认用户数据');
      await DefaultRepositoryImpl().postInfo();
      //3.创建后再次获取数据
      UserModel? userModel =await DefaultRepositoryImpl().getInfo();
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
  Future<bool> uploadPhoto(Map<String, Object> map) async {
    
   return  await DefaultRepositoryImpl().patchInfo(map);
  }
  
 

}
