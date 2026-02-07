/*
 * @Author: 张仕鹏 1120148291@qq.com
 * @Date: 2025-03-13 15:35:12
 * @LastEditors: 张仕鹏 1120148291@qq.com
 * @LastEditTime: 2025-03-13 15:45:45
 * @FilePath: /flutter-template-getx/lib/app/core/utils/logger_singleton.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter_demo2/app/core/values/app_values.dart';

import 'package:logger/logger.dart';

/// 日志单例类
/// 
/// 使用单例模式实现的日志管理器
/// 根据不同的应用环境（开发/生产）配置不同的日志级别
/// 提供统一的日志打印接口
class LoggerSingleton {
  /// 静态私有实例
  /// 
  /// 用于存储全局唯一的Logger实例
  static Logger? _instance;

  /// 私有构造函数
  /// 
  /// 防止外部直接创建实例
  LoggerSingleton._();

  /// 获取Logger实例
  /// 
  /// 如果实例不存在，则根据当前环境创建新的实例
  /// 开发环境使用debug级别，生产环境使用warning级别
  /// 
  /// 返回配置好的Logger实例
  static Logger getInstance() {
    if (_instance == null) {
      /// 根据环境设置日志级别
      Level logLevel = Level.debug;
      // switch (F.appFlavor) {
      //   case Flavor.dev:
      //     logLevel = Level.debug;    /// 开发环境：显示所有日志
      //     break;
      //   case Flavor.prod:
      //     logLevel = Level.warning;  /// 生产环境：只显示警告和错误
      //     break;
      //   default:
      //     logLevel = Level.debug;    /// 默认使用debug级别
      // }

      /// 创建Logger实例并配置打印选项
      _instance = Logger(
        level: logLevel,
        printer: PrettyPrinter(
          methodCount: AppValues.loggerMethodCount,      /// 显示的方法调用数量
          errorMethodCount: AppValues.loggerErrorMethodCount,  /// 错误时显示的方法调用数量
          lineLength: AppValues.loggerLineLength,        /// 输出行宽度
          colors: true,                                  /// 启用彩色输出
          printEmojis: true,                            /// 启用表情符号
          printTime: false                              /// 不显示时间戳
        ),
      );
    }
    return _instance!;
  }
}