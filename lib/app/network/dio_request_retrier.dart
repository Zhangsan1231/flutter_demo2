import 'package:dio/dio.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';

import 'package:get/get.dart' hide Response;
import '/app/network/dio_provider.dart';

/// Token 过期请求重试器
/// 
/// 主要功能：
/// 1. 处理 token 过期的情况
/// 2. 自动获取新的 token 并重试失败的请求
/// 3. 对用户无感知，提升用户体验
/// 
/// 使用场景：
/// - 当请求因为 token 过期而失败时
/// - 需要自动刷新 token 并重试请求时
/// - 与拦截器配合使用，实现自动 token 刷新机制
class DioRequestRetrier {
  /// Dio 客户端实例
  final dioClient = DioProvider.tokenClient;
  
  /// 原始请求选项
  final RequestOptions requestOptions;
  
  /// 存储服务实例
  final storage = SecureStorageService.instance;

  DioRequestRetrier({required this.requestOptions});

  /// 重试请求
  /// 自动获取新的 token 并重试失败的请求
  /// 返回类型为 Response<T>
  Future<Response<T>> retry<T>() async {
    try {
      // 获取自定义请求头
      var header = await getCustomHeaders();
      
      // 使用新的请求头重试请求
      return dioClient.request<T>(
        requestOptions.path,
        cancelToken: requestOptions.cancelToken,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        onReceiveProgress: requestOptions.onReceiveProgress,
        onSendProgress: requestOptions.onSendProgress,
        options: Options(
          headers: header, 
          method: requestOptions.method,
          // 保持原始请求的其他选项
          contentType: requestOptions.contentType,
          responseType: requestOptions.responseType,
          validateStatus: requestOptions.validateStatus,
          receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
          extra: requestOptions.extra,
        ),
      );
    } on DioException catch (e) {
      // 处理 Dio 相关错误
      print('请求重试失败: ${e.message}');
      rethrow;
    } catch (e) {
      // 处理其他错误
      print('请求重试发生未知错误: $e');
      rethrow;
    }
  }

  /// 获取自定义请求头
  /// 从存储中获取最新的 token 并构建请求头
  /// 返回包含认证信息的请求头 Map
  Future<Map<String, String>> getCustomHeaders() async {
    try {
      // 获取访问令牌
      final String? accessToken = await storage.getString(AppValues.idToken);
      
      // 基础请求头
      var customHeaders = {
        'content-type': 'application/json',
        'accept': 'application/json',
      };
      
      // 如果有访问令牌，添加到请求头
      if (accessToken != null && accessToken.trim().isNotEmpty) {
        customHeaders['Authorization'] = "Bearer $accessToken";
      }

      return customHeaders;
    } catch (e) {
      print('获取请求头失败: $e');
      // 返回基础请求头
      return {
        'content-type': 'application/json',
        'accept': 'application/json',
      };
    }
  }
}