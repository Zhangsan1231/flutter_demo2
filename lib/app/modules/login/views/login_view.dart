import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/widget/custom_appbar.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends BaseViews<LoginController> {

  
  @override
  Widget? appBar(BuildContext context) {
   return CustomAppBar(
    title: Text("login页面"),
   );
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
  
}
