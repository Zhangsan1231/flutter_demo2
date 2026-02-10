import 'package:get/get_rx/src/rx_types/rx_types.dart';

/// 应用值常量类
/// 
/// 定义应用中使用的所有常量值
/// 包括日志配置、边距、圆角等通用数值
/// 使用静态常量管理，便于统一维护和修改
abstract class AppValues {
  /// 测试值常量
  static const String testValue = "TEST_VALUE";

  /// 令牌键名
  static const String idToken = "ID_TOKEN";

  /// API 区域设置的存储 key
  static const String apiRegionKey = "API_REGION";

  /// 用户信息存储 key
  static const String userInfoKey = "USER_INFO";

  static const String id = 'ID';

  /// 日志配置相关常量
  /// 
  /// 用于配置日志打印的格式和内容
  static const int loggerLineLength = 120;        /// 日志行长度
  static const int loggerErrorMethodCount = 8;    /// 错误日志显示的方法调用数量
  static const int loggerMethodCount = 2;         /// 普通日志显示的方法调用数量

  /// 边距相关常量
  /// 
  /// 用于统一管理UI布局中的各种边距值
  static const double margin = 16;               /// 标准边距
  static const double margin_zero = 0;           /// 零边距
  static const double smallMargin = 8;           /// 小边距
  static const double extraSmallMargin = 6;      /// 超小边距
  static const double largeMargin = 24;          /// 大边距
  static const double margin_40 = 40;            /// 40像素边距
  static const double margin_32 = 32;            /// 32像素边距
  static const double margin_18 = 18;            /// 18像素边距
  static const double margin_2 = 2;              /// 2像素边距
  static const double margin_4 = 4;              /// 4像素边距
  static const double margin_6 = 6;              /// 6像素边距
  static const double margin_12 = 12;            /// 12像素边距
  static const double margin_10 = 10;            /// 10像素边距
  static const double margin_30 = 30;            /// 30像素边距
  static const double margin_20 = 20;            /// 20像素边距

  /// 基础配置常量
  /// 
  /// 用于定义基础UI元素的尺寸
  static const double smallRadius = 8;           /// 小圆角半径
  static const double radius = 16;               /// 对话框圆角半径
  static const double LoginRadius = 36; //登录页面radius
  static const double LoginHeight = 287;//登录按钮长度
  static const double LoginWidth = 47;//登录按钮宽度
  static const double LoginTextSize = 16;

  /// 令牌相关常量
  static const String accessToken = "ACCESS_TOKEN";
  static const String refreshToken = "REFRESH_TOKEN";

  static const String locale = 'locale_key';

  static const String agreementValue = 'agreement_value';
  static const String userInfo = 'USER_INFO';
}
