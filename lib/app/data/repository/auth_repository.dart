import 'package:authing_sdk/result.dart';
import 'package:authing_sdk/user.dart';

abstract class AuthRepository {

  Future<bool> ensureUserInitialized();
  Future<String> wxLogin(String username,String password);

  Future<String> googleLogin(String username,String password);

  Future<String> loginEmailAndPassword(String username,String password);

  Future<Map<String,dynamic>> getUserDetails();

  Future<void> logoutl();
  
  Future<User> registerByEmail(String email, String password) ;
    

}