import 'dart:io';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_demo2/app/data/model/user_model.dart';

abstract class DefaultRepository {

  Future<UserModel?> getInfo();
  
  Future<void> postInfo([UserModel? user]);

  Future<bool> patchInfo(Map<String,Object> map);

  Future<String?> uploadImage(File file);


}