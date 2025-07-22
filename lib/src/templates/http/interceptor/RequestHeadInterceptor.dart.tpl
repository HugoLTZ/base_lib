// @type: interceptor  
// @description: Interceptor for adding authentication headers to requests
import 'dart:io';

import 'package:dio/dio.dart' as dio;

String platform = Platform.isAndroid ? "android" : "ios";

/// Interceptor for adding authentication headers to requests
class {{className}} extends dio.Interceptor {
  @override
  Future<void> onRequest(
    dio.RequestOptions options,
    dio.RequestInterceptorHandler handler,
  ) async {
    options.headers = getHeaders();

    return handler.next(options);
  }

  @override
  void onResponse(
      dio.Response response, dio.ResponseInterceptorHandler handler) {
    // Check for token expiration in response data
    if (response.data != null && response.data is Map) {
      final data = response.data as Map<String, dynamic>;
    }

    return handler.next(response);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  static Map<String, dynamic>? getHeaders() {
    /// 自定义Header,如需要添加token信息请调用此参数

    Map<String, dynamic> httpHeaders = {
      'Accept': 'application/json, text/plain, */*',
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': "*",
      "registration-id": "null",
    };
    return httpHeaders;
  }
} 