library base_lib;

// 导出初始化文件
export 'init.dart';

// ===== HTTP网络请求相关模块 =====
// API接口常量
export 'src/http/api/RequestApi.dart';

// HTTP请求工具类
export 'src/http/request/HttpRequest.dart';
// export 'src/http/request/StreamHttpRequest.dart' hide Success, Fail, Method;

// HTTP异常处理
export 'src/http/exception/HttpException.dart';

// HTTP拦截器
export 'src/http/interceptor/RequestHeadInterceptor.dart';
export 'src/http/interceptor/PrettyDioLogger.dart';

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
