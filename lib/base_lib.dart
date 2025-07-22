library base_lib;

// 导出初始化文件
export 'init.dart';

// ===== 第三方库导出 =====
// Flutter核心库
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter/foundation.dart';

// 状态管理 - 只导出 Riverpod，避免与 Dio 的冲突
export 'package:flutter_riverpod/flutter_riverpod.dart'
    hide describeIdentity, shortHash;
export 'package:get/get.dart' hide FormData, MultipartFile, Response;

// 网络请求 - 主要导出 Dio
export 'package:dio/dio.dart';
export 'package:connectivity_plus/connectivity_plus.dart';

// 本地存储
export 'package:shared_preferences/shared_preferences.dart';

// 日志记录
export 'package:logger/logger.dart';

// 工具库
export 'package:path/path.dart';

// 权限和系统功能
export 'package:permission_handler/permission_handler.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:path_provider/path_provider.dart';

// UI适配
export 'package:flutter_screenutil/flutter_screenutil.dart';

// ===== 页面基类模块 =====
export 'src/page/BasePage.dart';

// ===== 工具类模块 =====
// 日志工具类
export 'src/utils/LogUtils.dart';

// 本地存储工具类
export 'src/utils/Storageutils.dart';

// ===== 构建器模块 =====
// 模板构建器（主要用于代码生成）
export 'src/builders/TemplateBuilder.dart';

// ===== 代码生成器模块 =====
// 代码生成器API（编程式调用）
export 'src/generator/code_generator.dart';
