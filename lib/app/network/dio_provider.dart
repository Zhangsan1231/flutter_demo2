import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_demo2/app/core/model/region_unit.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/network/dio_request_retrier.dart';
import 'package:flutter_demo2/app/network/pretty_dio_logger.dart';
import 'package:flutter_demo2/app/network/request_header.dart';

/// Dio 网络请求提供者
/// 
/// 主要功能：
/// 1. 提供统一的 Dio 实例管理
/// 2. 配置网络请求的基础选项
/// 3. 管理请求拦截器
/// 4. 处理网络错误
class DioProvider {

static String get baseUrl =>
  SecureStorageService.instance.getRegion() == RegionUnit.zh
    ? 'https://aispine.aihnet.cn'
    : 'https://myaih.net';
//国内Base URL：https://aispine.aihnet.cn
//国外Base URL：https://myaih.net

static String foreginBaseUrl = 'https://myaih.net';
static String domesticBaseUrl = 'https://aispine.aihnet.cn';

static Dio? _instance;

/// 日志拦截器
  static final _prettyDioLogger = PrettyDioLogger(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: true,
    error: true,
    compact: true,
    maxWidth: 90,
  );
  /// 基础配置选项
  static final BaseOptions _options = BaseOptions(
    baseUrl: foreginBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: 'application/json',
    responseType: ResponseType.json,
    // validateStatus: (status) {
    //   // 只要不是500等致命错误，都让业务层自己处理
    //    return status != null && status >= 200 && status < 600;
    // }
  );
  /// 获取基础 Dio 实例（带日志拦截器）
  static Dio get httpDio {
    if (_instance == null) {
      _instance = Dio(_options);
      // 关闭证书校验，仅开发环境使用！
      (_instance!.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
      _instance!.interceptors.add(_prettyDioLogger);
    } else {
      _instance!.interceptors.clear();
      _instance!.interceptors.add(_prettyDioLogger);
    }
    return _instance!;
  }

    /// 获取带认证令牌的 Dio 实例
  /// 包含请求头拦截器和日志拦截器
  static Dio get tokenClient {
    _addInterceptors();
    return _instance!;
  }

/// 添加拦截器
  /// 包括：请求头拦截器、日志拦截器、错误处理拦截器
  static void _addInterceptors() {
    _instance ??= httpDio;
    _instance!.interceptors.clear();
    
    // 添加请求头拦截器
    _instance!.interceptors.add(RequestHeaderInterceptor());
    
    // 添加日志拦截器
    _instance!.interceptors.add(_prettyDioLogger);

    // 添加错误处理拦截器
    _instance!.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Token 过期，使用 DioRequestRetrier 重试请求
          try {
            final retrier = DioRequestRetrier(requestOptions: e.requestOptions);
            final response = await retrier.retry();
            return handler.resolve(response);
          } catch (retryError) {
            print("Token 刷新失败: $retryError");
            return handler.reject(e);
          }
        } else if (e.type == DioExceptionType.unknown) {
          // 处理网络错误
          print("网络错误: ${e.message}");
          // TODO: 添加网络错误提示
          handler.reject(e);
        } else {
          // 其他错误继续传递
          handler.next(e);
        }
      },
    ));
  }

  /// 设置自定义内容类型
  static void setContentType(String version) {
    _instance?.options.contentType = "user_defined_content_type+$version";
  }

  /// 设置 JSON 内容类型
  static void setContentTypeApplicationJson() {
    _instance?.options.contentType = "application/json";
  }
}