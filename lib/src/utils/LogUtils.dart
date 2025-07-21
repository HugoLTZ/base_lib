import 'package:logger/logger.dart';

/// 基于Logger库封装的日志工具类
class LogUtils {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // 显示调用栈的方法数
      errorMethodCount: 8, // 错误情况下显示调用栈的方法数
      lineLength: 120, // 每行的最大长度
      colors: true, // 是否使用颜色
      printEmojis: true, // 是否显示表情符号
    ),
  );

  static final Logger _simplelogger = Logger(
    printer: SimplePrinter(), // 简单输出
  );

  /// [DEBUG] 调试信息（标准格式化输出）
  static void d(dynamic message) {
    _logger.d(message);
  }

  /// [INFO] 关键状态信息（简洁无格式输出）
  static void i(dynamic message) {
    _simplelogger.i(message);
  }

  /// [WARNING] 警告信息（标准格式化输出）
  static void w(dynamic message) {
    _logger.w(message);
  }

  /// [ERROR] 错误日志（带错误对象和调用栈）
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// [TRACE] 调用链跟踪（开发专用）
  static void t(dynamic message) {
    _logger.t(message);
  }
}
