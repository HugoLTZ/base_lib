# 🎯 灵活的模板文件生成指南

你现在有**3种超级灵活**的方式来控制生成的文件名，完全无需修改模板文件！

## 🚀 方法1：交互式CLI工具（最简单）

### 🎮 交互模式
```bash
dart run tool/generate.dart
```
然后按照提示选择：
- 选择模板类型 (Page/Controller/Vars/Router)
- 输入文件名
- 输入类名（或留空自动生成）

### ⚡ 命令行模式
```bash
# 语法：dart run tool/generate.dart [type] [fileName] [className]
dart run tool/generate.dart page home_page HomePage
dart run tool/generate.dart controller user_controller UserController
dart run tool/generate.dart vars app_vars AppVars
dart run tool/generate.dart router app_router AppRouter
```

### 📂 输出目录映射
- `page` → `lib/pages/`
- `controller` → `lib/controllers/`
- `vars` → `lib/vars/`
- `router` → `lib/routes/`

---

## 📋 方法2：配置文件批量生成（最强大）

### 1️⃣ 编辑 `templates_config.yaml`
```yaml
templates:
  pages:
    - fileName: home_page
      className: HomePage
      template: basic_page.dart.tpl
    - fileName: user_profile_page
      className: UserProfilePage
      template: basic_page.dart.tpl
    - fileName: settings_page
      className: SettingsPage
      template: basic_page.dart.tpl

  controllers:
    - fileName: home_controller
      className: HomeController
      template: basic_controller.dart.tpl
    - fileName: user_controller
      className: UserController
      template: basic_controller.dart.tpl

  vars:
    - fileName: app_vars
      className: AppVars
      template: basic_vars.dart.tpl

  routes:
    - fileName: app_router
      className: AppRouter
      template: router.dart.tpl
```

### 2️⃣ 运行批量生成
```bash
dart run tool/template_generator.dart
```

这会一次性生成配置文件中定义的所有文件！

---

## 🎨 方法3：重命名模板文件（传统方式）

简单粗暴，适合单次使用：
```bash
# 想生成 login_page.dart
重命名：basic_page.dart.tpl → login_page.dart.tpl

# 想生成 auth_controller.dart  
重命名：basic_controller.dart.tpl → auth_controller.dart.tpl

# 然后运行
dart run build_runner build
```

---

## 🎯 使用场景推荐

### 🚀 **快速生成单个文件**
```bash
dart run tool/generate.dart page profile_page ProfilePage
```

### 📦 **新项目初始化**
编辑 `templates_config.yaml` 添加所有需要的页面和控制器，然后：
```bash
dart run tool/template_generator.dart
```

### 🔄 **持续开发**
使用交互模式，逐个生成需要的文件：
```bash
dart run tool/generate.dart
```

---

## ✨ 生成效果示例

### 📝 输入
```bash
dart run tool/generate.dart page user_profile_page UserProfilePage
```

### 📂 输出
- 文件：`lib/pages/user_profile_page.dart`
- 类名：`UserProfilePage`, `UserProfilePageState`
- 变量：`userProfilePage`

### 🔧 自动处理
- ✅ 自动创建目录（如果不存在）
- ✅ 智能命名转换（下划线 → 大驼峰）
- ✅ 自动生成对应的Provider名称

---

## 💡 高级技巧

### 🎨 **自定义模板变量**
在模板文件中可以使用：
- `{{className}}` - 大驼峰类名
- `{{littleName}}` - 小驼峰变量名

### 📁 **批量重构**
想要重新生成所有文件？修改 `templates_config.yaml` 然后重新运行即可！

### 🛠️ **集成到VS Code**
在 `tasks.json` 中添加：
```json
{
  "label": "Generate Template",
  "type": "shell",
  "command": "dart run tool/generate.dart",
  "group": "build",
  "presentation": {
    "echo": true,
    "reveal": "always",
    "focus": false,
    "panel": "shared"
  }
}
```

---

🎉 **现在你拥有了完全的控制权！**无需修改任何模板文件，就能灵活生成任意文件名和类名的代码文件！ 