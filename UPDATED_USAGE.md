# 🎉 Base Lib 代码生成功能 - 全新使用方式

## ✨ 重大更新

**现在无需复制 `tool/` 目录！** base_lib 已集成可执行文件，其他项目可以直接调用代码生成功能。

## 🚀 新的使用方式

### 方式一：直接命令行调用（推荐）

其他项目现在可以直接使用：

```bash
# 交互式生成
dart pub run base_lib:generate

# 命令行直接生成
dart pub run base_lib:generate page home_page HomePage
dart pub run base_lib:generate controller user_controller UserController
dart pub run base_lib:generate module LoginPage
```

### 方式二：编程式API调用（新增）

在你的 Dart 代码中直接调用：

```dart
import 'package:base_lib/base_lib.dart';

void main() async {
  // 生成单个页面
  await CodeGenerator.generatePage('HomePage');
  
  // 生成控制器
  await CodeGenerator.generateController('UserController');
  
  // 生成完整页面模块
  final files = await CodeGenerator.generatePageModule('ProductPage');
  print('Generated files: $files');
}
```

## 📦 项目集成步骤

### 1. 添加依赖

在你的 `pubspec.yaml` 中：

```yaml
dependencies:
  base_lib:
    path: ../base_lib  # 或者 git/pub 地址
  # base_lib 需要的依赖
  flutter_riverpod: ^2.6.1
  get: ^4.7.2
  shared_preferences: ^2.5.3
  dio: ^5.8.0+1
  logger: ^2.6.0
  connectivity_plus: ^6.1.4
```

### 2. 开始使用（无需复制任何文件！）

```bash
# 进入你的项目目录
cd my_flutter_project

# 直接使用 base_lib 的代码生成功能
dart pub run base_lib:generate
```

## 🎨 使用示例

### 交互式生成示例

```bash
$ dart pub run base_lib:generate

🎯 Base Lib Template Generator
===================================

📋 Select template type:
1. Page
2. Controller
3. Vars
4. Router
5. Page Module (页面+控制器+变量)    # ← 推荐选择
6. Exit

Enter your choice (1-6): 5
📝 Enter class name (e.g., LoginPage): ShoppingCartPage

🚀 Generating page module for: ShoppingCartPage
📁 Module directory: lib/pages/shopping_cart_page/

✅ Page module generated successfully!
📂 Files created:
   - lib/pages/shopping_cart_page/ShoppingCartPage.dart
   - lib/pages/shopping_cart_page/controller/ShoppingCartPageController.dart
   - lib/pages/shopping_cart_page/vars/ShoppingCartPageVars.dart
```

### 编程式API示例

```dart
// 在你的项目中使用
import 'package:base_lib/base_lib.dart';

class MyCodeGenerator {
  static Future<void> generateProjectFiles() async {
    // 生成完整页面模块
    final loginFiles = await CodeGenerator.generatePageModule('LoginPage');
    print('Login module files: $loginFiles');
    
    // 生成单独的控制器
    final userController = await CodeGenerator.generateController('UserController');
    print('User controller: $userController');
    
    // 生成变量类
    final appVars = await CodeGenerator.generateVars('AppVars');
    print('App vars: $appVars');
  }
}
```

## 🎯 模板智能查找

base_lib 现在具有智能模板查找功能：

1. **优先级1**: 查找当前项目的 `lib/src/templates/` 目录（自定义模板）
2. **优先级2**: 使用 base_lib 包中的模板文件
3. **优先级3**: 使用内置的默认模板

这意味着你可以：
- 直接使用 base_lib 的默认模板（零配置）
- 在项目中创建自定义模板覆盖默认行为

## 🔧 自定义模板（可选）

如果你想自定义模板，只需在项目中创建：

```
your_project/
├── lib/
│   └── src/
│       └── templates/           # 可选的自定义模板目录
│           ├── basic_page.dart.tpl
│           ├── basic_controller.dart.tpl
│           ├── basic_vars.dart.tpl
│           └── router.dart.tpl
└── pubspec.yaml
```

## 🆚 新旧方式对比

### ❌ 旧方式（已弃用）
```bash
# 需要手动复制文件
cp -r ../base_lib/tool/ ./tool/
dart run tool/generate.dart
```

### ✅ 新方式（推荐）
```bash
# 直接调用，无需复制任何文件
dart pub run base_lib:generate
```

## 📱 生成的代码特性

生成的代码自动包含：

- ✅ 继承 `BasePage` 基类，统一页面架构
- ✅ 集成 `Riverpod` 状态管理
- ✅ 导入 `base_lib` 的所有工具类
- ✅ 标准的 Flutter 项目结构
- ✅ 智能的命名转换（大驼峰、小驼峰、下划线）

### 示例生成的页面代码：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_lib/base_lib.dart';

class ShoppingCartPage extends BasePage {
  const ShoppingCartPage({super.key});
  @override
  BasePageState<BasePage> createState() {
    return ShoppingCartPageState();
  }
}

class ShoppingCartPageState extends BasePageState<ShoppingCartPage> {
  @override
  bool get showAppBar => true;

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    // 可以直接使用 base_lib 的工具类
    LogUtils.i('ShoppingCartPage 页面已加载');
    
    return Container(
      child: Center(
        child: Text("ShoppingCartPage"),
      ),
    );
  }
}
```

## 🎁 额外功能

### 编程式批量生成

```dart
// 一次性生成多个模块
Future<void> generateApp() async {
  final modules = ['HomePage', 'UserPage', 'SettingsPage'];
  
  for (final module in modules) {
    await CodeGenerator.generatePageModule(module);
  }
  
  print('✅ 应用模块生成完成！');
}
```

### 自定义输出目录

```dart
// 自定义输出路径
await CodeGenerator.generatePage('AdminPage', outputDir: 'lib/admin/pages');
await CodeGenerator.generateController('AdminController', outputDir: 'lib/admin/controllers');
```

## 🏆 总结

新的 base_lib 代码生成功能提供了：

1. **零配置使用** - 无需复制任何文件
2. **双重接口** - 命令行 + 编程式API
3. **智能模板** - 自动查找和内置备选
4. **完整架构** - 一键生成整个页面模块
5. **高度定制** - 支持自定义模板和输出路径

现在就开始享受更加便捷的 Flutter 开发体验吧！🚀 