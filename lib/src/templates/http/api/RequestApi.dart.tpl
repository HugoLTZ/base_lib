// @type: api
// @description: API constants for the application
import 'package:flutter/foundation.dart';

/// API constants for the application
class {{className}} {
  // 根据构建模式自动选择环境
  static String get baseurl {
    if (kDebugMode) {
      // 调试模式：使用开发环境
      return '';
    } else {
      // 发布模式：使用生产环境
      return '';
    }
  }

  //测试
  static String get test => '$baseurl/test';

  /// 获取当前环境信息（用于调试）
  static String get currentEnvironment {
    return kDebugMode ? 'Development' : 'Production';
  }

  /// 打印当前使用的API环境（用于调试）
  static void printCurrentEnvironment() {
    print('🌐 当前API环境: $currentEnvironment');
    // print('🔗 API Base URL: $baseurl');
  }
} 