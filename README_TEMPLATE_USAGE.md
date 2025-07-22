# 🎯 Base Lib 代码生成功能使用指南

## 📖 概述

base_lib 提供了强大的代码生成功能，支持快速生成 Flutter 项目中的常用模板：页面、控制器、变量类和路由。

## 🚀 使用方式

### 方式一：交互式命令行生成（推荐）

```bash
dart run tool/generate.dart
```

#### 功能菜单：
1. **Page** - 生成基于 BasePage 的页面文件
2. **Controller** - 生成基于 Riverpod 的状态管理控制器
3. **Vars** - 生成变量类文件
4. **Router** - 生成基于 GetX 的路由文件
5. **Page Module** - 一键生成完整页面模块（页面+控制器+变量）
6. **Exit** - 退出生成器

#### 示例操作：
```bash
# 启动交互式生成器
dart run tool/generate.dart

# 选择 5 (Page Module)
# 输入类名：LoginPage
# 自动生成：
#   - lib/pages/login_page/LoginPage.dart
#   - lib/pages/login_page/controller/LoginPageController.dart  
#   - lib/pages/login_page/vars/LoginPage.dart
```

### 方式二：命令行直接生成

```bash
# 单个文件生成
dart run tool/generate.dart [type] [fileName] [className]

# 页面模块生成
dart run tool/generate.dart module [className]
```

#### 示例：
```bash
# 生成页面
dart run tool/generate.dart page home_page HomePage

# 生成控制器
dart run tool/generate.dart controller user_controller UserController

# 生成完整页面模块
dart run tool/generate.dart module LoginPage
```

### 方式三：Build Runner 自动生成

使用 build_runner 和模板文件：

```bash
# 运行构建
flutter packages pub run build_runner build

# 或者监听模式
flutter packages pub run build_runner watch
```

## 📁 生成的文件结构

### 单个页面生成：
```
lib/pages/
  └── home_page.dart
```

### 完整页面模块生成：
```
lib/pages/login_page/
  ├── LoginPage.dart              # 页面文件
  ├── controller/
  │   └── LoginPageController.dart # 控制器文件
  └── vars/
      └── LoginPage.dart          # 变量文件
```

## 🎨 模板详解

### 1. 页面模板 (basic_page.dart.tpl)
生成基于 `BasePage` 的 Flutter 页面：
- 继承 BasePage 基类
- 集成 Riverpod 状态管理
- 预设页面结构和生命周期

### 2. 控制器模板 (basic_controller.dart.tpl)
生成 Riverpod 状态管理控制器：
- StateNotifier 模式
- 自动注入 Provider
- 状态管理样板代码

### 3. 变量模板 (basic_vars.dart.tpl)  
生成变量类：
- 页面相关常量和配置
- 类型安全的变量管理

### 4. 路由模板 (router.dart.tpl)
生成 GetX 路由配置：
- 路由名称定义
- GetPage 配置
- 导航管理

## ⚙️ 自定义模板

### 模板变量
所有模板支持以下变量替换：
- `{{className}}` - 类名（大驼峰）
- `{{littleName}}` - 实例名（小驼峰）

### 修改模板
模板文件位于：`lib/src/templates/`
- `basic_page.dart.tpl` - 页面模板
- `basic_controller.dart.tpl` - 控制器模板  
- `basic_vars.dart.tpl` - 变量模板
- `router.dart.tpl` - 路由模板

## 📦 在其他项目中使用

### 1. 添加依赖
```yaml
# pubspec.yaml
dependencies:
  base_lib:
    path: ../path/to/base_lib  # 或 git/pub 地址

dev_dependencies:
  build_runner: ^2.4.7
  build: ^2.4.1
```

### 2. 配置构建规则
创建 `build.yaml`：
```yaml
targets:
  $default:
    builders:
      base_lib|template_builder:
        enabled: true
        generate_for:
          - lib/src/templates/**

builders:
  template_builder:
    import: "package:base_lib/src/builders/TemplateBuilder.dart"
    builder_factories: ["templateBuilder"]
    build_extensions: 
      ".dart.tpl": [".dart"]
    auto_apply: none
    build_to: source
```

### 3. 复制生成工具
将 `tool/` 目录复制到你的项目中，即可使用命令行生成功能。

## 🎯 最佳实践

1. **使用页面模块生成**：推荐使用选项5一键生成完整模块
2. **命名规范**：使用大驼峰命名类名（如：LoginPage、UserController）
3. **目录结构**：保持生成的目录结构，便于项目管理
4. **模板定制**：根据项目需要修改模板文件

## 🔧 常见问题

**Q: 如何修改生成的文件路径？**
A: 修改 `tool/generate.dart` 中的 `_getOutputPath` 方法。

**Q: 如何添加新的模板类型？**
A: 在 `lib/src/templates/` 添加新模板，并在生成工具中注册。

**Q: 生成的代码报错怎么办？**
A: 确保项目已添加必要依赖（flutter_riverpod、get等）。

## 📞 技术支持

如有问题，请查看：
- 模板文件：`lib/src/templates/`
- 生成工具：`tool/generate.dart`
- 构建配置：`build.yaml` 