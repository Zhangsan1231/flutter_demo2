import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/core/utils/logger.dart';
import 'package:flutter_demo2/app/network/dio_provider.dart';
import 'package:flutter_demo2/app/network/error_handlers.dart';
import 'package:flutter_demo2/app/network/exceptions/base_exception.dart';
import 'package:flutter_demo2/app/network/exceptions/business_exception.dart';
import 'package:get/get.dart' hide Response;

import 'package:get/route_manager.dart';


/// 基础仓储类
///
/// 提供网络请求的基础功能：
/// 1. 统一的错误处理
/// 2. 响应数据格式验证
/// 3. 日志记录
/// 4. 本地存储访问
abstract class BaseRepository {
  /// 获取带认证的 Dio 客户端实例
  Dio get dioClient => DioProvider.tokenClient;

  /// 日志记录器实例
  final logger = LoggerSingleton.getInstance();

  /// 本地存储服务实例
  final storage = SecureStorageService.instance;



  /// 调用 API 并处理错误
  ///
  /// [api] 要执行的 API 请求
  ///
  /// 返回类型：
  /// - 成功：返回 API 响应数据
  /// - 失败：抛出异常
  ///
  /// 处理流程：
  /// 1. 执行 API 请求
  /// 2. 验证响应状态码
  /// 3. 验证响应数据格式
  /// 4. 处理错误情况
  Future<Response<T>> callApiWithErrorParser<T>(Future<Response<T>> api) async {
    try {
      // 执行 API 请求
      Response<T> response = await api;

      // 验证响应状态码
      if (response.statusCode == HttpStatus.badRequest) {
        // 处理 400 错误
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          final message = data['message'] as String?;
          final code = data['code']?.toString();

          if (message != null) {
            throw BusinessException(
              message: message,
              errorCode: code ?? 'VALIDATION_ERROR',
              errorData: data,
            );
          }
        }
        throw BusinessException(
          message: '请求参数错误',
          errorCode: 'BAD_REQUEST',
        );
      } else 
      if (response.statusCode != HttpStatus.ok &&
          response.statusCode != 201) {
        throw Exception('HTTP 状态码异常: ${response.statusCode}');
      }

      // 验证响应数据格式
      if (response.data is Map<String, dynamic>) {
        // 处理 Map 类型响应
        // TODO: 根据实际业务需求添加响应码验证
        // if ((response.data as Map<String, dynamic>)['code'] != 1) {
        //   throw Exception('API 错误: ${response.data}');
        // }
      } else if (response.data is List) {
        // 处理 List 类型响应
        // TODO: 根据实际业务需求添加列表数据验证
      } else {
        throw Exception('响应数据格式异常: ${response.data}');
      }

      return response;
    } 
    on DioException catch (dioError) {
      // 处理 Dio 网络请求错误
      Exception exception = handleDioError(dioError);
      logger.e(
          "仓储层错误: >>>>>>> $exception : ${(exception as BaseException).message}");
          Get.snackbar(dioError.toString(), exception.message);
      // ToastUtil.showError(Get.context!, exception.message);
      throw exception;
    } 
    catch (error) {
      // 处理其他类型错误
      logger.e("通用错误: >>>>>>> $error");
      

      if (error is BaseException) {
        rethrow;
      }

      throw handleError("$error");
    }
  }
}
