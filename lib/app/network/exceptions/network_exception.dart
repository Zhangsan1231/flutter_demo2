import '/app/network/exceptions/base_exception.dart';

// 表示网络异常
class NetworkException extends BaseException {
  NetworkException(String message) : super(message: message);
}
