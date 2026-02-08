import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/core/translations/app_translations.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mmkv/mmkv.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 初始化 MMKV
  final rootDir = await MMKV.initialize();
  print('MMKV 初始化完成，根目录：$rootDir');

  // 2. 初始化語言設定（必須在 runApp 之前完成）
  await _initLanguage();

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