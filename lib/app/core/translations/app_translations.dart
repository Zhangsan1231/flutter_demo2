import 'package:get/get.dart';

import 'translation_keys.dart';

class AppTranslations extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US':_en,
    'zh_CN':{..._en, ..._zhOverrides}
  };
   final Map<String, String> _en = {
     TL.appName: 'AIH',
      TL.loading: 'Loading...',
      TL.success: 'Success',
      TL.error: 'Error',

      //登录
      TL.weChatlogin: 'WeChat Login',
      TL.googleLogin: 'Google Login',
   };

   // 中文翻译（覆盖）
  final Map<String, String> _zhOverrides = {
    TL.appName: 'AIH',
      TL.loading: '加载中...',
      TL.success: '成功',
      TL.error: '错误',

      //登录
      TL.weChatlogin: '微信登陆',
      TL.googleLogin: '谷歌登录',
  };
}
