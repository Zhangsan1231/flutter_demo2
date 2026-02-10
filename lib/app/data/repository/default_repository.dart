import 'package:flutter_demo2/app/data/model/user_model.dart';

abstract class DefaultRepository {

  Future<UserModel?> getInfo();
  
  Future<void> postInfo([UserModel? user]);
}