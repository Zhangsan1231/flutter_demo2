/*
 * @Author: 张仕鹏 1120148291@qq.com
 * @Date: 2024-07-16 17:27:07
 * @LastEditors: 张仕鹏 1120148291@qq.com
 * @LastEditTime: 2025-08-20 13:40:11
 * @FilePath: /rpmappmaster/lib/app/core/base/remote/base_remote_source.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
// import 'package:aiCare/app/core/utils/logger_singleton.dart';
// import 'package:aiCare/app/core/utils/toast_util.dart';
// import 'package:aiCare/app/core/translations/translation_keys.dart'
//     as TranslationKeys;
import 'package:dio/dio.dart' as dio;
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/core/utils/logger.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:get/get_connect/http/src/utils/utils.dart' as TranslationKeys;
// import 'package:aiCare/app/core/service/storage_service.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';

import '/app/network/dio_provider.dart';
import '/app/network/error_handlers.dart';
import '/app/network/exceptions/base_exception.dart';
import '/app/network/exceptions/api_exception.dart';
// import '/flavors/build_config.dart';

abstract class BaseRemoteSource {
  dio.Dio get dioClient => DioProvider.tokenClient;

  final logger = LoggerSingleton.getInstance();

  final storage = SecureStorageService.instance;

  // 创建一个 Map 来存储所有的 cancelToken
  final Map<String, dio.CancelToken> _cancelTokens = {};

  // 获取或创建 cancelToken
  dio.CancelToken getCancelToken(String key) {
    if (!_cancelTokens.containsKey(key)) {
      _cancelTokens[key] = dio.CancelToken();
    }
    return _cancelTokens[key]!;
  }

  // 取消指定的请求
  void cancelRequest(String key) {
    if (_cancelTokens.containsKey(key)) {
      _cancelTokens[key]?.cancel('Request cancelled');
      _cancelTokens.remove(key);
    }
  }

  // 取消所有请求
  void cancelAllRequests() {
    _cancelTokens.forEach((key, token) {
      token.cancel('All requests cancelled');
    });
    _cancelTokens.clear();
  }

  // Future<dio.Response<T>> callApiWithErrorParser<T>(
  //     Future<dio.Response<T>> api) async {
  //   try {
  //     dio.Response<T> response = await api;
  //     var path = response.requestOptions.uri.path;

  //     if (response.requestOptions.uri.path.contains("/info") ||
  //         response.requestOptions.uri.path
  //             .contains("/profiles/vital_signs/target_values")) {
  //       return response;
  //     }

  //     // logger.d("查看callApiWithErrorParser的response");
  //     // logger.d(response.toString());

  //     // 检查 HTTP 状态码
  //     if (response.statusCode != HttpStatus.ok && response.statusCode != 201) {
  //       //判断url，如果是 info 则返回response

  //       String errorMessage = TranslationKeys.T.requestFailed.tr;
  //       if (response.data is Map<String, dynamic>) {
  //         final data = response.data as Map<String, dynamic>;
  //         errorMessage = data['message'] ??
  //             "${TranslationKeys.T.requestFailed.tr}: ${response.statusCode}";
  //       }
  //       throw ApiException(
  //         httpCode: response.statusCode ?? -1,
  //         status: response.statusMessage ?? "Unknown Error",
  //         message: errorMessage,
  //       );
  //     }
  //     // logger.d("response.data: ${response.data}");

  //     // 检查响应数据格式
  //     if (response.data is Map<String, dynamic>) {
  //       final data = response.data as Map<String, dynamic>;
  //       // 检查业务状态码，1代表有数据，-1代表无数据，0代表请求失败，服务器trycatch返回的
  //       //如果是第三方，就判断是否 token_type 为null
  //       if (data['token_type'] == "Bearer") {
  //         return response;
  //       }
  //       if (data['code'] == 0 || data['code'] == null) {
  //         String errorMessage =
  //             data['message'] ?? TranslationKeys.T.serverError.tr;
  //         ToastUtil.showError(Get.context!, errorMessage);
  //         throw ApiException(
  //           httpCode: response.statusCode ?? -1,
  //           status: data['status'] ?? "Error",
  //           message: errorMessage,
  //         );
  //       } else if (data['code'] != 1 && data['code'] != -1) {
  //         // 除了 1（有数据）、-1（无数据）、0（服务器错误）之外的状态码都是异常
  //         String errorMessage =
  //             data['message'] ?? TranslationKeys.T.requestFailed.tr;
  //         throw ApiException(
  //           httpCode: response.statusCode ?? -1,
  //           status: data['status'] ?? "Error",
  //           message: errorMessage,
  //         );
  //       }
  //       // code 为 1 或 -1 的情况正常处理，不抛出异常
  //     }
  //     // 处理列表数据
  //     else if (response.data is List) {
  //       // 列表数据直接通过
  //     } else {
  //       logger.d("response.data: ${response.data}");
  //       throw ApiException(
  //         httpCode: response.statusCode ?? -1,
  //         status: "Invalid Response",
  //         message: "响应数据格式错误",
  //       );
  //     }

  //     return response;
  //   } on dio.DioException catch (dioError) {
  //     // 处理 Dio 错误
  //     if (dioError.type == dio.DioExceptionType.cancel) {
  //       logger.d("请求已被取消: ${dioError.message}");
  //       throw ApiException(
  //         httpCode: -1,
  //         status: "Cancelled",
  //         message: "请求已被取消",
  //       );
  //     }

  //     if (dioError.type == dio.DioExceptionType.badResponse) {
  //       String errorMessage = "请求失败";
  //       if (dioError.response?.data is Map<String, dynamic>) {
  //         final data = dioError.response?.data as Map<String, dynamic>;
  //         errorMessage = data['message'] ?? "请求失败";
  //       }
  //       throw ApiException(
  //         httpCode: dioError.response?.statusCode ?? -1,
  //         status: dioError.response?.statusMessage ?? "Error",
  //         message: errorMessage,
  //       );
  //     }

  //     Exception exception = handleDioError(dioError);
  //     // logger.e(response.data);
  //     logger.e(
  //         "Throwing error from repository: >>>>>>> $exception : ${(exception as BaseException).message}");
  //     throw exception;
  //   } catch (error) {
  //     logger.e("Generic error: >>>>>>> $error");

  //     if (error is BaseException) {
  //       rethrow;
  //     }

  //     throw handleError("$error");
  //   }
  // }

}
