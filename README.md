# Base Lib - Flutter 开发基础库

## 🚀 概述

Base Lib 是一个全面的 Flutter 开发基础库，提供了统一的页面架构、网络请求、状态管理、工具类和强大的代码生成功能。

## ✨ 主要功能

### 📱 核心模块
- **BasePage** - 统一的页面基类架构
- **HttpRequest** - 网络请求工具（支持普通和流式请求）
- **LogUtils** - 日志管理工具
- **StorageUtils** - 本地存储工具
- **RequestApi** - API接口常量管理

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
  flutter_riverpod: ^2.6.1
  get: ^4.7.2
  shared_preferences: ^2.5.3
  dio: ^5.8.0+1
  logger: ^2.6.0
  connectivity_plus: ^6.1.4
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
import 'package:base_lib/base_lib.dart';
import 'pages/user_profile_page/UserProfilePage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserProfilePage(), // 使用生成的页面
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

## 🔧 高级功能

### 自定义模板
在项目中创建 `lib/src/templates/` 目录，放入自定义模板文件即可覆盖默认模板。

### 编程式批量生成
```dart
Future<void> initProject() async {
  final modules = ['HomePage', 'UserPage', 'SettingsPage'];
  for (final module in modules) {
    await CodeGenerator.generatePageModule(module);
  }
}
```

### 网络请求示例
```dart
// 使用内置的网络请求工具
await HttpRequest.request(
  Method.GET,
  '/api/users',
  {},
  success: (data) => LogUtils.i('Success: $data'),
  fail: (code, msg) => LogUtils.e('Error: $code - $msg'),
);
```

## 📚 文档

- [详细使用指南](README_TEMPLATE_USAGE.md)
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
