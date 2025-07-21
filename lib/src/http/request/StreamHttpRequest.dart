import 'dart:convert';

import 'package:base_lib/src/utils/LogUtils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../api/RequestApi.dart';
import '../exception/HttpException.dart';
import '../interceptor/PrettyDioLogger.dart';
import '../interceptor/RequestHeadInterceptor.dart';

/// 连接超时时间
const Duration _connectTimeout = Duration(seconds: 90);

/// 接受超时时间
const Duration _receiveTimeout = Duration(seconds: 120);

/// 发送超时时间
const Duration _sendTimeout = Duration(seconds: 90);

typedef Success<T> = Function(T data);
typedef Fail = Function(int code, String msg);
typedef OnData<T> = Function(T data);
typedef OnDone = Function();

/// @class : StreamHttpRequest
/// @name :
/// @description : 流式响应请求工具
class StreamHttpRequest {
  ///全局Dio对象
  static Dio? _dio;

  /// 创建 dio 实例对象
  static Dio createInstance([bool isJson = false]) {
    if (_dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      var options = BaseOptions(
        ///提交方式：1.表单提交 2.JSON方式提交
        contentType: isJson
            ? Headers.jsonContentType
            : Headers.formUrlEncodedContentType,
        validateStatus: (status) {
          /// 不使用http状态码判断状态
          return true;
        },
        baseUrl: RequestApi.baseurl,
        sendTimeout: _sendTimeout,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
      );
      _dio = Dio(options);
      _dio?.interceptors.add(RequestHeadInterceptor());
      _dio?.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false, // 禁止记录流式响应体，避免日志过大
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
          logPrint: (log) {
            LogUtils.i("stream_dio:$log");
          }));
      _dio?.options.contentType =
          isJson ? Headers.jsonContentType : Headers.formUrlEncodedContentType;
    }
    return _dio!;
  }

  /// 流式请求方法
  /// [method]：请求方法，Method.POST等
  /// [path]：请求地址
  /// [params]：请求参数
  /// [onData]：每次接收数据的回调
  /// [onDone]：请求完成回调
  /// [error]：请求失败回调
  static Future streamRequest(Method method, String path, dynamic params,
      {bool isJson = false,
      required OnData onData,
      OnDone? onDone,
      required Fail? fail}) async {
    try {
      ///请求前先检查网络连接
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        _onError(HttpException.netError, '网络异常，请检查你的网络！', fail);
        return;
      }

      Dio dio = createInstance(isJson);

      // 配置流式响应
      final options = Options(
        method: _methodValues[method],
        responseType: ResponseType.stream,
      );

      final response = await dio.request(
        path,
        data: params,
        options: options,
      );

      // 处理流式响应
      final stream = response.data.stream;

      stream.listen(
        (chunk) {
          // 处理 Server-Sent Events (SSE) 格式
          final String chunkString = utf8.decode(chunk);
          final List<String> lines = chunkString.split('\n');

          for (var line in lines) {
            if (line.startsWith('data:')) {
              final data = line.substring(5).trim();
              if (data.isNotEmpty) {
                try {
                  final jsonData = json.decode(data);
                  onData(jsonData);
                } catch (e) {
                  LogUtils.e("JSON解析失败: $data, 错误: $e");
                }
              }
            }
          }
        },
        onDone: onDone,
        onError: (error) {
          final NetError netError = HttpException.handleException(error);
          _onError(netError.code, netError.msg, fail);
        },
      );
    } on DioException catch (e) {
      final NetError netError = HttpException.handleException(e);
      _onError(netError.code, netError.msg, fail);
      LogUtils.d("流式请求异常=====>$e");
    }
  }
}

/// 错误回调
/// [code] 错误代码
/// [msg] 错误信息
/// [fail] 错误回调
void _onError(int code, String msg, Fail? fail) {
  if (code == 0) {
    code = HttpException.unknownError;
    msg = '未知异常';
  }
  if (fail != null) {
    fail(code, msg);
  }
}

///请求类型枚举
enum Method { GET, POST, DELETE, PUT, PATCH, HEAD }

///请求类型值
const _methodValues = {
  Method.GET: "get",
  Method.POST: "post",
  Method.DELETE: "delete",
  Method.PUT: "put",
  Method.PATCH: "patch",
  Method.HEAD: "head",
};
