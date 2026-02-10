import '/app/network/exceptions/base_api_exception.dart';

// 用来创建 API 相关的异常
class ApiException extends BaseApiException {
  ApiException({
    required int httpCode,
    required String status,
    String message = "",
  }) : super(httpCode: httpCode, status: status, message: message);
}
