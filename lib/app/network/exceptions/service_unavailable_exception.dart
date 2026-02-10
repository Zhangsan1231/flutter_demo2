import 'dart:io';

import 'package:flutter_demo2/app/network/exceptions/base_api_exception.dart';


// 服务不可用的错误 503
class ServiceUnavailableException extends BaseApiException {
  ServiceUnavailableException(String message)
      : super(
            httpCode: HttpStatus.serviceUnavailable,
            message: message,
            status: "");
}
