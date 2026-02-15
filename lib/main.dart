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

  // 先清空存储（如果你只是为了测试）
   storage.deleteAll(); // 建议只在调试时用，生产环境不要随意清空

  // 读取当前地区值
  var regionValue = storage.getRegion();
  print("初始读取的地区值: $regionValue");

  // 只有当地区是 nu（未设置）时才去查询 IP 并设置
  if (regionValue == RegionUnit.nu) {
    print("地区未设置，开始通过 IP 判断...");

    try {
      final response = await http.get(Uri.parse('http://ip-api.com/json'));
      print("IP 接口响应: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final countryCode = data['countryCode'] as String?;
        print('国家代码: $countryCode');

        if (countryCode == null) {
          print("IP 接口未返回 countryCode，默认英文");
          await storage.setRegion(RegionUnit.en);
        } else if (countryCode == 'CN' || countryCode == 'SG') {
          await storage.setRegion(RegionUnit.zh);
          print("设置为中文环境 (zh)");
        } else {
          await storage.setRegion(RegionUnit.en);
          print("设置为英文环境 (en)");
        }

        // 重新读取确认是否设置成功
        regionValue = storage.getRegion();
        print("设置后最终地区值: $regionValue");
      } else {
        print("IP 接口请求失败，状态码: ${response.statusCode}，默认英文");
        await storage.setRegion(RegionUnit.en);
      }
    } catch (e) {
      print('获取 IP 位置失败: $e，默认设置为英文');
      await storage.setRegion(RegionUnit.en);
    }
  } else {
    print("地区已设置过，无需查询 IP，直接使用: $regionValue");
  }

  // 最后打印确认
  print("remoteInit 结束，最终地区: ${storage.getRegion()}");
}
Future<void> _initLanguage() async {
  final storage = SecureStorageService.instance;
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