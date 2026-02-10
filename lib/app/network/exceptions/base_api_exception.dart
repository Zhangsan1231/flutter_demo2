import '/app/network/exceptions/app_exception.dart';

//默认Api http状态码为 -1
abstract class BaseApiException extends AppException {
  final int httpCode;
  final String status;

  BaseApiException({this.httpCode = -1, this.status = "", String message = ""})
      : super(message: message);
}
