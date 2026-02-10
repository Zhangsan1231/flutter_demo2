import 'dart:math' as math;
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class PrettyDioLogger extends dio.Interceptor {
  /// 是否打印请求信息
  final bool request;

  /// 是否打印请求头信息
  final bool requestHeader;

  /// 是否打印请求体信息
  final bool requestBody;

  /// 是否打印响应体信息
  final bool responseBody;

  /// 是否打印响应头信息
  final bool responseHeader;

  /// 是否打印错误信息
  final bool error;

  /// JSON 响应打印的初始缩进数
  static const int initialTab = 1;

  /// 缩进单位
  static const String tabStep = '    ';

  /// 是否使用紧凑格式打印 JSON
  final bool compact;

  /// 每行最大宽度
  final int maxWidth;

  /// 日志打印函数
  /// 在 Flutter 中，建议使用 debugPrint
  /// 也可以将日志写入文件
  void Function(Object object) logPrint;

  static const int defaultMaxWidth = 90;

  PrettyDioLogger({
    this.request = false,      // 不打印请求信息
    this.requestHeader = true, // 只打印请求头
    this.requestBody = false,  // 不打印请求体
    this.responseHeader = false, // 不打印响应头
    this.responseBody = false,   // 不打印响应体
    this.error = false,         // 不打印错误信息
    this.maxWidth = defaultMaxWidth,
    this.compact = true,
    this.logPrint = print,
  });

  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    if (request) {
      _printRequestHeader(options);
    }
    if (requestHeader) {
      _printMapAsTable(options.queryParameters, header: '查询参数');
      final requestHeaders = <String, dynamic>{};
      requestHeaders.addAll(options.headers);
      requestHeaders['contentType'] = options.contentType?.toString();
      requestHeaders['responseType'] = options.responseType.toString();
      requestHeaders['followRedirects'] = options.followRedirects;
      requestHeaders['connectTimeout'] = options.connectTimeout;
      requestHeaders['receiveTimeout'] = options.receiveTimeout;
      _printMapAsTable(requestHeaders, header: '请求头');
      _printMapAsTable(options.extra, header: '额外信息');
    }
    if (requestBody && options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data is Map) _printMapAsTable(options.data as Map?, header: '请求体');
        if (data is dio.FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          _printMapAsTable(formDataMap, header: '表单数据 | ${data.boundary}');
        } else {
          _printBlock(data.toString());
        }
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    if (error) {
      if (err.type == dio.DioExceptionType.badResponse) {
        final uri = err.response?.requestOptions.uri;
        _printBoxed(
            header:
                'Dio错误 ║ 状态码: ${err.response?.statusCode} ${err.response?.statusMessage}',
            text: uri.toString());
        if (err.response != null && err.response?.data != null) {
          logPrint('╔ ${err.type.toString()}');
          _printResponse(err.response!);
        }
        _printLine('╚');
        logPrint('');
      } else {
        _printBoxed(header: 'Dio错误 ║ ${err.type}', text: err.message);
      }
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(dio.Response response, dio.ResponseInterceptorHandler handler) {
    _printResponseHeader(response);
    if (responseHeader) {
      final responseHeaders = <String, String>{};
      response.headers
          .forEach((k, list) => responseHeaders[k] = list.toString());
      _printMapAsTable(responseHeaders, header: '响应头');
    }

    if (responseBody) {
      logPrint('╔ 响应体');
      logPrint('║');
      _printResponse(response);
      logPrint('║');
      _printLine('╚');
    }
    super.onResponse(response, handler);
  }

  void _printBoxed({String? header, String? text}) {
    logPrint('');
    logPrint('╔╣ $header');
    logPrint('║  $text');
    _printLine('╚');
  }

  void _printResponse(dio.Response response) {
    if (response.data != null) {
      if (response.data is Map) {
        _printPrettyMap(response.data as Map);
      } else if (response.data is List) {
        logPrint('║${_indent()}[');
        _printList(response.data as List);
        logPrint('║${_indent()}[');
      } else {
        _printBlock(response.data.toString());
      }
    }
  }

  void _printResponseHeader(dio.Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    _printBoxed(
        header:
            '响应 ║ $method ║ 状态码: ${response.statusCode} ${response.statusMessage}',
        text: uri.toString());
  }

  void _printRequestHeader(dio.RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    _printBoxed(header: '请求 ║ $method ', text: uri.toString());
  }

  void _printLine([String pre = '', String suf = '╝']) =>
      logPrint('$pre${'═' * maxWidth}$suf');

  void _printKV(String? key, Object? v) {
    final pre = '╟ "$key": ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      logPrint(pre);
      _printBlock(msg);
    } else {
      logPrint('$pre$msg');
    }
  }

  void _printBlock(String msg) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      logPrint((i >= 0 ? '║ ' : '') +
          msg.substring(i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  String _indent([int tabCount = initialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    Map data, {
    int tabs = initialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var _tabs = tabs;
    final isRoot = _tabs == initialTab;
    final initialIndent = _indent(_tabs);
    _tabs++;

    if (isRoot || isListItem) logPrint('║$initialIndent{');

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'(\r|\n)+'), " ")}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value)) {
          logPrint('║${_indent(_tabs)} "$key": $value${!isLast ? ',' : ''}');
        } else {
          logPrint('║${_indent(_tabs)} "$key": {');
          _printPrettyMap(value, tabs: _tabs);
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value)) {
          logPrint('║${_indent(_tabs)} "$key": ${value.toString()}');
        } else {
          logPrint('║${_indent(_tabs)} "$key": [');
          _printList(value, tabs: _tabs);
          logPrint('║${_indent(_tabs)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(_tabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            logPrint(
                '║${_indent(_tabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}');
          }
        } else {
          logPrint('║${_indent(_tabs)} "$key": $msg${!isLast ? ',' : ''}');
        }
      }
    });

    logPrint('║$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  void _printList(List list, {int tabs = initialTab}) {
    int tabsCount = 2;
    list.asMap().forEach((i, dynamic e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && _canFlattenMap(e)) {
          logPrint('║${_indent(tabs)}  $e${!isLast ? ',' : ''}');
        } else {
          _printPrettyMap(e, tabs: tabs + 1, isListItem: true, isLast: isLast);
        }
      } else {
        logPrint('║${_indent(tabs + tabsCount)} $e${isLast ? '' : ','}');
      }
    });
  }

  bool _canFlattenMap(Map map) {
    return map.values
            .where((dynamic val) => val is Map || val is List)
            .isEmpty &&
        map.toString().length < maxWidth;
  }

  bool _canFlattenList(List list) {
    int maxListLength = 10;

    return list.length < maxListLength && list.toString().length < maxWidth;
  }

  void _printMapAsTable(Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;
    logPrint('╔ $header ');
    map.forEach(
        (dynamic key, dynamic value) => _printKV(key.toString(), value));
    _printLine('╚');
  }
}