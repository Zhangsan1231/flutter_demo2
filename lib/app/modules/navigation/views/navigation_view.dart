import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/modules/home/views/home_view.dart';
import 'package:flutter_demo2/app/modules/information/views/information_view.dart';
import 'package:flutter_demo2/app/modules/login/views/login_view.dart';
import 'package:flutter_demo2/app/modules/splash/views/splash_view.dart';
import 'package:flutter_demo2/app/modules/user/views/user_view.dart';
import 'package:get/get.dart';
import 'package:flutter_demo2/app/core/base/base_views.dart';
import 'package:flutter_demo2/app/core/model/page_background_.dart';
import 'package:flutter_demo2/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/navigation_controller.dart';

class NavigationView extends BaseViews<NavigationController> {
  NavigationView({super.key})
    : super(
        bgImage: PageBackground(
          imagePath: Assets.images.backgronud.path, // 注意拼寫改成 background
          top: 0.0,
          left: 0.0,
          width: 375.w,
          // width: Get.width,           // 螢幕寬度
          // height: Get.height+MediaQuery.of(Get.context!).padding.top,         // 螢幕高度
          height: 812.w + MediaQuery.of(Get.context!).padding.top,
          fit: BoxFit.fitHeight, // 建議用 cover 全屏鋪滿
        ),
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // 看圖片顏色決定
      );

  @override
  Widget? appBar(BuildContext context) {
    // TODO: implement appBar
    return Container();
  }
 RxInt currentIndex = 0.obs;
  @override
  Widget body(BuildContext context) {
   

    // TODO: implement body
    return Obx(() => Stack(children: [IndexedStack(
      index: currentIndex.value,
      children: [
        SplashView(),
        LoginView(),
        HomeView(),
        InformationView(),
      ],
    ),
    Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      
      child: BottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: SwitchTap,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.red,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: '首页'),
           BottomNavigationBarItem(icon: Icon(Icons.home),label: '首页'),
            BottomNavigationBarItem(icon: Icon(Icons.home),label: '首页'),
             BottomNavigationBarItem(icon: Icon(Icons.home),label: '首页'),
        ])
    
    ),
    ]));
  }
  void SwitchTap(int index){
    currentIndex.value = index ;
    logger.d(currentIndex.value);

  }
}


//  Container(

      
      
    //   child: BottomNavigationBar(
    //     items: <BottomNavigationBarItem>[

        
    //       BottomNavigationBarItem(icon: Icon(Icons.home),label: '首页'),
    //       BottomNavigationBarItem(icon: Icon(Icons.home),label: '首页'),
    //       BottomNavigationBarItem(icon: Icon(Icons.home),label: '首页'),
    //       BottomNavigationBarItem(icon: Icon(Icons.home),label: '首页'),
    //   ],
    //   selectedItemColor: Colors.redAccent,//被选中的图标和文字颜色
    //   unselectedItemColor: Colors.black45,//未选中的图标和文字颜色
    //   ),
    // )
