import 'package:flutter_demo2/app/network/exceptions/base_exception.dart';

/// 业务逻辑异常
/// 
/// 用于处理业务层面的错误，如：
/// - 用户名重复
/// - 数据验证失败
/// - 业务规则冲突
class BusinessException extends BaseException {
  final String errorCode;
  final dynamic errorData;

  BusinessException({
    required String message,
    this.errorCode = 'BUSINESS_ERROR',
    this.errorData,
  }) : super(message: message);

  @override
  String toString() => 'BusinessException: $message (code: $errorCode)';
} 