# Base Lib - Flutter 开发基础库

## 🚀 概述

Base Lib 是一个全面的 Flutter 开发基础库，提供了统一的页面架构、网络请求、状态管理、工具类和强大的代码生成功能。

## ✨ 主要功能

### 📱 核心模块
- **BasePage** - 统一的页面基类架构
- **LogUtils** - 日志管理工具
- **StorageUtils** - 本地存储工具

### 📦 第三方库导出
- **一站式导入** - 只需导入 `base_lib` 即可使用所有常用第三方库
- **冲突解决** - 自动处理库之间的命名冲突
- **包含库**：Flutter核心库、Riverpod、Dio、SharedPreferences、Logger等

### 🎯 代码生成功能（重点特性）

**🎉 无需复制任何文件！** 现在可以直接通过命令调用代码生成功能：

#### 方式一：命令行调用
```bash
# 交互式生成
dart pub run base_lib:generate

# 命令行直接生成
dart pub run base_lib:generate page home_page HomePage
dart pub run base_lib:generate controller user_controller UserController
dart pub run base_lib:generate module LoginPage  # 生成完整页面模块
```

#### 方式二：编程式API
```dart
import 'package:base_lib/base_lib.dart';

// 生成页面模块
await CodeGenerator.generatePageModule('ProductPage');

// 生成单个组件
await CodeGenerator.generatePage('HomePage');
await CodeGenerator.generateController('UserController');
```

## 📦 快速开始

### 1. 添加依赖

```yaml
dependencies:
  base_lib:
    path: ../base_lib  # 或者你的库路径
```

### 2. 生成页面模块

```bash
dart pub run base_lib:generate module UserProfilePage
```

这将自动生成：
- `lib/pages/user_profile_page/UserProfilePage.dart` - 页面文件
- `lib/pages/user_profile_page/controller/UserProfilePageController.dart` - 控制器
- `lib/pages/user_profile_page/vars/UserProfilePageVars.dart` - 变量类

### 3. 使用生成的代码

```dart
// 一行导入即可使用所有功能：Material UI、Riverpod、Dio、日志等
import 'package:base_lib/base_lib.dart';
import 'pages/user_profile_page/UserProfilePage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(  // Riverpod 已导出
      child: MaterialApp(  // Material UI 已导出
        home: UserProfilePage(), // 使用生成的页面
      ),
    );
  }
}

// 在页面中可以直接使用所有导出的库
class HomePage extends BasePage {
  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        // 直接使用 Riverpod
        return Center(child: Text('Welcome!'));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 直接使用 Dio 和 Logger
          final dio = Dio();
          try {
            final response = await dio.get('https://api.example.com');
            LogUtils.i('Response: ${response.data}');
          } catch (e) {
            LogUtils.e('Error: $e');
          }
        },
        child: Icon(Icons.download),
      ),
    );
  }
}
```

## 🎨 生成的代码特性

- ✅ 继承 `BasePage` 统一页面架构
- ✅ 集成 `Riverpod` 状态管理
- ✅ 自动导入所有工具类
- ✅ 智能命名转换
- ✅ 标准项目结构

## 📐 代码规范与架构设计

### 页面模块结构设计

Base Lib 采用**模块化页面架构**，每个页面都是一个独立的模块，包含三个核心部分：

```
lib/pages/user_profile_page/
├── UserProfilePage.dart           # 📱 页面UI层
├── controller/
│   └── UserProfilePageController.dart  # 🎮 业务逻辑层
└── vars/
    └── UserProfilePageVars.dart        # 🎨 UI样式变量层
```

### 代码规范

#### 1. **架构层级职责**
- **Page层** (`*.dart`) - 纯UI展示，负责界面布局和用户交互
- **Controller层** (`controller/`) - 业务逻辑处理，事件响应和数据操作  
- **Vars层** (`vars/`) - UI样式变量，颜色、字体、尺寸等样式常量


#### 2. **命名规范**
- **文件命名**: 使用 PascalCase，如 `UserProfilePage.dart`
- **目录命名**: 使用 snake_case，如 `user_profile_page/`
- **类命名**: 统一后缀，如 `UserProfilePageController`、`UserProfilePageVars`

### HTTP模块结构设计

HTTP相关代码统一放置在 `lib/src/http/` 目录下：

```
lib/src/http/
├── api/
│   └── RequestApi.dart          # 📡 API接口定义
├── exception/
│   └── HttpException.dart       # ⚠️ 异常处理
├── interceptor/
│   ├── PrettyDioLogger.dart     # 📝 日志拦截器
│   └── RequestHeadInterceptor.dart  # 🔐 请求头拦截器
└── request/
    └── HttpRequest.dart         # 🌐 请求工具类
```


## 📚 文档

- [详细使用指南](README_TEMPLATE_USAGE.md)
- [HTTP模板使用指南](HTTP_TEMPLATE_USAGE.md)
- [第三方库导出说明](LIBRARY_EXPORTS.md)
- [新功能说明](UPDATED_USAGE.md)
- [使用示例](example_usage.md)

## 🏆 优势

1. **零配置** - 无需复制任何文件即可使用
2. **统一架构** - 确保团队代码风格一致
3. **提升效率** - 快速生成标准化代码
4. **灵活定制** - 支持自定义模板和配置
5. **双重接口** - 命令行和编程式两种调用方式

## 📞 技术支持

如有问题，请查看相关文档或提交 Issue。
