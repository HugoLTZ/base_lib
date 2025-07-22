# HTTP Template Generator 使用指南

## 概述

HTTP Template Generator 是 Base Lib 项目的一部分，用于快速生成HTTP相关的代码文件，包括API接口、异常处理、拦截器和请求工具类。

## 支持的模板类型

### 单个文件模板
- **HTTP API** (`http_api`): API接口常量类
- **HTTP Exception** (`http_exception`): HTTP异常处理类
- **HTTP Interceptor** (`http_interceptor`): Dio拦截器（日志/请求头）
- **HTTP Request** (`http_request`): HTTP请求工具类
- **HTTP Stream Request** (`http_stream_request`): 流式HTTP请求工具类

### 模块模板
- **HTTP Module** (`http_module`): 完整的HTTP模块（包含所有HTTP相关文件）

## 使用方法

### 1. 命令行方式

#### 生成单个HTTP文件
```bash
dart run tool/generate.dart [type] [fileName] [className]
```

**示例：**
```bash
# 生成API文件
dart run tool/generate.dart http_api user_api UserApi

# 生成异常处理文件
dart run tool/generate.dart http_exception custom_exception CustomException

# 生成拦截器文件
dart run tool/generate.dart http_interceptor auth_interceptor AuthInterceptor

# 生成请求工具文件
dart run tool/generate.dart http_request user_request UserRequest

# 生成流式请求文件
dart run tool/generate.dart http_stream_request stream_request StreamRequest
```

#### 生成完整HTTP模块
```bash
dart run tool/generate.dart http_module [projectName]
```

**示例：**
```bash
dart run tool/generate.dart http_module MyProject
```

这将生成以下文件结构：
```
lib/http/
├── api/
│   └── MyProjectApi.dart
├── exception/
│   └── MyProjectException.dart
├── interceptor/
│   ├── PrettyDioLogger.dart
│   └── RequestHeadInterceptor.dart
└── request/
    ├── MyProjectRequest.dart
    └── StreamMyProjectRequest.dart
```

### 2. 交互模式

运行不带参数的命令进入交互模式：
```bash
dart run tool/generate.dart
```

选择相应的选项：
- `6`: HTTP API
- `7`: HTTP Exception  
- `8`: HTTP Interceptor
- `9`: HTTP Request
- `10`: HTTP Stream Request
- `11`: HTTP Module (完整HTTP模块)

## 生成的文件说明

### API文件 (RequestApi.dart.tpl)
- 包含API端点常量
- 支持开发/生产环境切换
- 提供基础的API接口定义

### 异常处理文件 (HttpException.dart.tpl)
- HTTP状态码常量定义
- 异常处理方法
- 网络错误封装

### 拦截器文件
- **PrettyDioLogger**: 格式化的请求/响应日志
- **RequestHeadInterceptor**: 请求头处理和Token管理

### 请求工具文件
- **HttpRequest**: 标准HTTP请求工具
- **StreamHttpRequest**: 流式HTTP请求工具（支持SSE）

## 目录结构

生成的文件将放置在以下目录：
```
lib/http/
├── api/          # API接口常量
├── exception/    # 异常处理类
├── interceptor/  # 拦截器类
└── request/      # 请求工具类
```

## 模板变量

所有模板都支持以下变量替换：
- `{{className}}`: 类名（首字母大写）
- `{{littleName}}`: 小驼峰类名（首字母小写）

## 依赖说明

生成的HTTP文件依赖以下包：
- `dio`: HTTP客户端
- `connectivity_plus`: 网络连接检测
- `base_lib`: 日志工具等基础功能

请确保在 `pubspec.yaml` 中添加相应依赖。

## 自定义

如需自定义模板，可以编辑 `lib/src/templates/http/` 目录下的模板文件：
- 添加配置注释 `// @type: [类型]`
- 使用 `{{className}}` 和 `{{littleName}}` 作为占位符
- 保持 `.tpl` 扩展名 