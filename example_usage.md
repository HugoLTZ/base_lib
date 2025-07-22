# 🎯 在实际项目中使用 base_lib 代码生成功能

## 🚀 快速开始示例

假设你有一个新的 Flutter 项目 `my_app`，想要使用 base_lib 的代码生成功能：

### 步骤 1: 添加依赖

在你的项目 `pubspec.yaml` 中添加：

```yaml
# my_app/pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 添加 base_lib 依赖
  base_lib:
    path: ../base_lib  # 相对路径，或者使用 git url
    
  # base_lib 需要的核心依赖
  flutter_riverpod: ^2.6.1
  get: ^4.7.2
  shared_preferences: ^2.5.3
  dio: ^5.8.0+1
  logger: ^2.6.0
  connectivity_plus: ^6.1.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.7
  build: ^2.4.1
```

### 步骤 2: 复制生成工具

将 base_lib 的 `tool/` 目录复制到你的项目中：

```bash
# 在你的项目根目录
cp -r ../base_lib/tool/ ./tool/
```

### 步骤 3: 开始使用

#### 方法一：交互式生成（推荐）

```bash
cd my_app
dart run tool/generate.dart
```

选择操作示例：
```
📋 Select template type:
1. Page
2. Controller
3. Vars
4. Router
5. Page Module (页面+控制器+变量)    # ← 选择这个
6. Exit

Enter your choice (1-6): 5
📝 Enter class name (e.g., LoginPage): ProductListPage

🚀 Generating page module for: ProductListPage
📁 Module directory: lib/pages/product_list_page/

✅ Page module generated successfully!
📂 Files created:
   - lib/pages/product_list_page/ProductListPage.dart
   - lib/pages/product_list_page/controller/ProductListPageController.dart
   - lib/pages/product_list_page/vars/ProductListPage.dart
```

#### 方法二：命令行直接生成

```bash
# 生成完整页面模块
dart run tool/generate.dart module UserProfilePage

# 生成单个组件
dart run tool/generate.dart page home_page HomePage
dart run tool/generate.dart controller cart_controller CartController
```

### 步骤 4: 查看生成的代码

生成的页面文件 `lib/pages/product_list_page/ProductListPage.dart`：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_lib/base_lib.dart';  // 导入 base_lib

class ProductListPage extends BasePage {  // 继承 BasePage
  const ProductListPage({super.key});
  
  @override
  BasePageState<BasePage> createState() {
    return ProductListPageState();
  }
}

class ProductListPageState extends BasePageState<ProductListPage> {
  @override
  bool get showAppBar => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    return Container(
      child: Center(
        child: Text("ProductListPage"),
      ),
    );
  }
}
```

生成的控制器文件 `lib/pages/product_list_page/controller/ProductListPageController.dart`：

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListPageControllerState {
  // 状态定义
}

final productListPageControllerProvider = 
    StateNotifierProvider.autoDispose<ProductListPageController, ProductListPageControllerState>((ref) {
  return ProductListPageController();
});

class ProductListPageController extends StateNotifier<ProductListPageControllerState> {
  ProductListPageController() : super(ProductListPageControllerState());
  
  // 业务逻辑方法
}
```

### 步骤 5: 在应用中使用

在你的 `main.dart` 中：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_lib/base_lib.dart';  // 导入 base_lib
import 'pages/product_list_page/ProductListPage.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: ProductListPage(),  // 使用生成的页面
    );
  }
}
```

## 🎨 自定义和扩展

### 自定义模板

如果你想修改生成的代码风格：

1. 复制 base_lib 的模板文件：
```bash
mkdir -p lib/src/templates
cp ../base_lib/lib/src/templates/*.tpl lib/src/templates/
```

2. 修改模板文件，比如 `lib/src/templates/basic_page.dart.tpl`：
```dart
// 自定义页面模板
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_lib/base_lib.dart';

class {{className}} extends BasePage {
  const {{className}}({super.key});
  
  @override
  String get title => '{{className}}';  // 添加默认标题
  
  @override
  BasePageState<BasePage> createState() => {{className}}State();
}

class {{className}}State extends BasePageState<{{className}}> {
  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    // 使用 base_lib 的工具类
    LogUtils.i('{{className}} 页面已加载');
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('欢迎来到 {{className}}'),
            ElevatedButton(
              onPressed: () {
                // 使用 base_lib 的存储工具
                StorageUtils.put('last_page', '{{className}}');
              },
              child: Text('保存访问记录'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 网络请求示例

在生成的控制器中使用 base_lib 的网络功能：

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_lib/base_lib.dart';

class ProductListPageController extends StateNotifier<ProductListPageControllerState> {
  ProductListPageController() : super(ProductListPageControllerState());
  
  // 使用 base_lib 的网络请求
  Future<void> loadProducts() async {
    await HttpRequest.request(
      Method.GET,
      '/api/products',
      {},
      success: (data) {
        LogUtils.i('产品数据加载成功: $data');
        // 更新状态
      },
      fail: (code, msg) {
        LogUtils.e('加载失败: $code - $msg');
      },
    );
  }
}
```

## 🏆 最佳实践

1. **项目结构**：
```
my_app/
├── lib/
│   ├── pages/           # 生成的页面
│   │   ├── home_page/
│   │   └── product_list_page/
│   ├── controllers/     # 全局控制器
│   ├── vars/           # 全局变量
│   └── routes/         # 路由配置
├── tool/               # 复制的生成工具
└── pubspec.yaml
```

2. **命名规范**：
   - 页面：`HomePage`、`UserProfilePage`
   - 控制器：`HomeController`、`UserController`
   - 变量类：`AppVars`、`ApiVars`

3. **模块化开发**：
   - 使用 Page Module 生成完整功能模块
   - 每个页面包含自己的控制器和变量
   - 保持代码组织清晰

## 🎯 总结

通过以上步骤，你就可以在任何 Flutter 项目中使用 base_lib 的强大代码生成功能了！生成的代码自动集成了：

- ✅ 统一的页面基类 (BasePage)
- ✅ 状态管理 (Riverpod)
- ✅ 网络请求工具 (HttpRequest)
- ✅ 日志工具 (LogUtils)
- ✅ 本地存储 (StorageUtils)
- ✅ 标准的项目结构

这大大提高了开发效率，确保代码风格统一，减少重复工作！🚀 