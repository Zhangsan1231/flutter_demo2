import 'package:authing_sdk/client.dart';
import 'package:authing_sdk/result.dart';
import 'package:authing_sdk/user.dart';
import 'package:flutter_demo2/app/core/base/base_repository.dart';
import 'package:flutter_demo2/app/core/model/region_unit.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
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
      logger.d(password);
      
      AuthResult response = await AuthClient.loginByAccount(username, password);

      // logger.d("当前登录Response：${response.user?.token}");
      // logger.d(response);
      // logger.d(response.code);
      final user = response.user;
      // SecureStorageService().setUserInfo(user as UserModel);
      logger.d('SecureStorageService().getUserInfo()?.name; :${SecureStorageService().getUserInfo()?.name}');
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
    } else {
      return '登录失败';
    }
    // TODO: implement loginEmailAndPassword
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
  Future<bool> uploadUserProfile(Map<String, Object> map) async {
    
   return  await DefaultRepositoryImpl().patchInfo(map);
  }
  
 

}
