# Base Lib 第三方库导出

## 概述

Base Lib 已导出所有项目中使用的第三方库，您只需导入 `base_lib` 即可使用所有功能，无需单独添加每个依赖。

## 已导出的库

### Flutter 核心库
- ✅ `package:flutter/material.dart` - Material Design 组件
- ✅ `package:flutter/services.dart` - 系统服务接口
- ✅ `package:flutter/foundation.dart` - 基础工具类

### 状态管理
- ✅ `package:flutter_riverpod/flutter_riverpod.dart` - 现代状态管理方案

### 网络请求
- ✅ `package:dio/dio.dart` - 强大的HTTP客户端
- ✅ `package:connectivity_plus/connectivity_plus.dart` - 网络连接检测

### 本地存储
- ✅ `package:shared_preferences/shared_preferences.dart` - 本地数据存储

### 日志记录
- ✅ `package:logger/logger.dart` - 美观的日志输出

### 工具库
- ✅ `package:path/path.dart` - 路径处理工具

### 权限和系统功能
- ✅ `package:permission_handler/permission_handler.dart` - 权限管理
- ✅ `package:url_launcher/url_launcher.dart` - URL启动器
- ✅ `package:path_provider/path_provider.dart` - 系统路径获取

## 使用方式

### 简化导入
```dart
// ❌ 以前需要多个导入
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

// ✅ 现在只需一个导入
import 'package:base_lib/base_lib.dart';
```

### 使用示例

#### 1. 状态管理 (Riverpod)
```dart
import 'package:base_lib/base_lib.dart';

// 定义Provider
final counterProvider = StateProvider<int>((ref) => 0);

class CounterPage extends BasePage {
  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: Consumer(
        builder: (context, ref, child) {
          final count = ref.watch(counterProvider);
          return Center(
            child: Text('$count', style: Theme.of(context).textTheme.headline1),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read(counterProvider.notifier).state++,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

#### 2. 网络请求 (Dio)
```dart
import 'package:base_lib/base_lib.dart';

class ApiService {
  final Dio _dio = Dio();
  
  Future<Map<String, dynamic>> fetchUser(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      return response.data;
    } on DioError catch (e) {
      LogUtils.e('API Error: ${e.message}');
      rethrow;
    }
  }
}
```

#### 3. 本地存储 (SharedPreferences)
```dart
import 'package:base_lib/base_lib.dart';

class UserPreferences {
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
    LogUtils.i('Username saved: $name');
  }
  
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
```

#### 4. 权限管理 (Permission Handler)
```dart
import 'package:base_lib/base_lib.dart';

class PermissionService {
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      LogUtils.i('Camera permission granted');
      return true;
    } else {
      LogUtils.w('Camera permission denied');
      return false;
    }
  }
}
```

#### 5. URL启动器
```dart
import 'package:base_lib/base_lib.dart';

class LinkService {
  static Future<void> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      LogUtils.i('Opened URL: $url');
    } else {
      LogUtils.e('Could not launch $url');
    }
  }
}
```

#### 6. 路径处理 (Path)
```dart
import 'package:base_lib/base_lib.dart';
import 'package:path/path.dart' as path;

class FileService {
  static Future<String> getDocumentPath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return path.join(directory.path, fileName);
  }
}
```

## 注意事项

### 1. 冲突解决
由于某些库存在命名冲突，我们已经隐藏了冲突的符号：
- `flutter_riverpod` 隐藏了 `describeIdentity`, `shortHash`

### 2. Get 框架
如果您需要使用 Get 框架，请单独导入以避免与 Dio 的冲突：
```dart
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
```

### 3. 可选库
以下库由于可能的冲突或特殊用途，建议按需单独导入：
- `flutter_screenutil` - 屏幕适配
- `webview_flutter` - WebView组件
- `json_serializable` - JSON序列化注解
- `yaml` - YAML解析

## 完整示例

```dart
import 'package:base_lib/base_lib.dart';

class ExamplePage extends BasePage {
  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Base Lib Demo'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () async {
              // 使用日志
              LogUtils.i('Info button pressed');
              
              // 检查网络连接
              final connectivity = await Connectivity().checkConnectivity();
              if (connectivity != ConnectivityResult.none) {
                // 发起网络请求
                final dio = Dio();
                try {
                  final response = await dio.get('https://api.github.com');
                  LogUtils.d('API Response: ${response.statusCode}');
                } catch (e) {
                  LogUtils.e('Network error: $e');
                }
              }
              
              // 保存到本地
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('last_action', 'info_clicked');
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return Column(
            children: [
              Text('Welcome to Base Lib!'),
              ElevatedButton(
                onPressed: () => openUrl('https://flutter.dev'),
                child: Text('Open Flutter.dev'),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Future<void> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
```

通过 Base Lib 的库导出功能，您可以更简洁地管理依赖，减少导入语句，提高开发效率！ 