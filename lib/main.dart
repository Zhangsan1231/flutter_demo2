import 'dart:convert';
import 'dart:ui';
import 'package:authing_sdk/authing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/model/region_unit.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/core/translations/app_translations.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';
import 'package:flutter_demo2/flavors/env_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mmkv/mmkv.dart';
import 'package:http/http.dart' as http;

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 初始化 MMKV
  final rootDir = await MMKV.initialize();
  print('MMKV 初始化完成，根目录：$rootDir');

  // 2. 初始化語言設定（必須在 runApp 之前完成）
  await _initLanguage();
  await remoteInit();

  await _initSetting();
  // 3. 啟動應用
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          translations: AppTranslations(),
          
          // 從本地儲存讀取語言，如果沒有則使用剛剛初始化的值
          locale: _getSavedLocale(),
          
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          title: "Application",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}
Future<void> _initSetting() async{

  //配置开发环境参数
  final devConfig = EnvConfig(baseUrlCN: 'https://aispine.aihnet.cn',
   basUrlOUT:'https://myaih.net', 
   userPoolId: '617f57a540eb446b2603de64', 
   appId: '628b26330995e701146bc591', 
   auho0Domain: 'https://aicare.authing.cn');
   Authing.init(devConfig.userPoolId, devConfig.appId);
}

remoteInit() async {
  final storage = SecureStorageService.instance;
  final regionValue = storage.getRegion();
  // storage.deleteAll();
  print("regionValue: $regionValue");
  if (regionValue == RegionUnit.nu) {
    // 如果没有设置过API区域，尝试通过IP判断用户所在地区
    try {
      final response = await http.get(Uri.parse('http://ip-api.com/json'));
      print("regionresponse: ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final countryCode = data['countryCode'] as String;

        if (countryCode == 'CN' || countryCode == 'SG') {
          // 同时设置地区 + 语言偏好
          SecureStorageService.instance.setRegion(RegionUnit.zh);
          // SecureStorageService.instance.setString(AppValues.locale, 'zh_CN');

          // 可选：即时更新当前语言（虽然重启后也会生效，但可以提升体验）
          // Get.updateLocale(const Locale('zh', 'CN'));
        } else {
          SecureStorageService.instance.setRegion(RegionUnit.en);
          // SecureStorageService.instance.setString(AppValues.locale, 'en_US');
          // Get.updateLocale(const Locale('en', 'US'));
        }
        // SecureStorageService.instance.setRegion(RegionUnit.en);
        print("当前服务器环境：${SecureStorageService.instance.getRegion()}");
        print(
            "当前语言设置：${SecureStorageService.instance.getString(AppValues.locale)}");
      }
    } catch (e) {
      print('Failed to get IP location: $e');
      // 如果发生错误，默认设置为英文环境
      SecureStorageService.instance.setRegion(RegionUnit.en);
    }
  }
}

Future<void> _initLanguage() async {
  final storage = SecureStorageService.instance;
  storage.deleteAll();
  // 先讀取一次
  String? savedLocale = await storage.getString(AppValues.locale);

  // 如果已經有值，就直接結束
  if (savedLocale != null) {
    return;
  }

  // 第一次安裝 → 判斷系統語言
  final systemLocale = PlatformDispatcher.instance.locale;
  final languageCode = systemLocale.languageCode;
  print('1111111111111111$languageCode');

  final defaultLocale = languageCode == 'zh' ? 'zh_CN' : 'en_US';

  // 單獨儲存，不接收任何返回值
  storage.setString( AppValues.locale,defaultLocale,);
  
  // 可以加一行 log 確認是否真的執行到這裡
  print('已初始化語言為: $defaultLocale');
}
/// 從儲存中取得當前語言（用於 GetMaterialApp 的 locale）
Locale _getSavedLocale() {
  final saved = SecureStorageService.instance.getString(AppValues.locale) ?? 'en_US';

  if (saved == 'zh_CN') {
    return const Locale('zh', 'CN');
  } else {
    return const Locale('en', 'US');
  }
}