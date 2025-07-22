import 'dart:io';
import 'package:path/path.dart' as path;

/// 代码生成器API类
///
/// 提供编程式的代码生成功能，其他项目可以直接调用而无需使用命令行工具
class CodeGenerator {
  /// 生成页面文件
  ///
  /// [className] 页面类名，如 'HomePage'
  /// [outputDir] 输出目录，默认为 'lib/pages'
  static Future<String> generatePage(String className,
      {String? outputDir}) async {
    outputDir ??= 'lib/pages';
    final fileName = _classNameToSnakeCase(className);
    final outputPath = path.join(outputDir, '$fileName.dart');

    final content = _getPageTemplate()
        .replaceAll('{{className}}', className)
        .replaceAll('{{littleName}}', _generateLittleName(className));

    await _writeFile(outputPath, content);
    return outputPath;
  }

  /// 生成控制器文件
  ///
  /// [className] 控制器类名，如 'HomeController'
  /// [outputDir] 输出目录，默认为 'lib/controllers'
  static Future<String> generateController(String className,
      {String? outputDir}) async {
    outputDir ??= 'lib/controllers';
    final fileName = _classNameToSnakeCase(className);
    final outputPath = path.join(outputDir, '$fileName.dart');

    final content = _getControllerTemplate()
        .replaceAll('{{className}}', className)
        .replaceAll('{{littleName}}', _generateLittleName(className));

    await _writeFile(outputPath, content);
    return outputPath;
  }

  /// 生成变量类文件
  ///
  /// [className] 变量类名，如 'AppVars'
  /// [outputDir] 输出目录，默认为 'lib/vars'
  static Future<String> generateVars(String className,
      {String? outputDir}) async {
    outputDir ??= 'lib/vars';
    final fileName = _classNameToSnakeCase(className);
    final outputPath = path.join(outputDir, '$fileName.dart');

    final content = _getVarsTemplate()
        .replaceAll('{{className}}', className)
        .replaceAll('{{littleName}}', _generateLittleName(className));

    await _writeFile(outputPath, content);
    return outputPath;
  }

  /// 生成路由文件
  ///
  /// [className] 路由类名，如 'AppRouter'
  /// [outputDir] 输出目录，默认为 'lib/routes'
  static Future<String> generateRouter(String className,
      {String? outputDir}) async {
    outputDir ??= 'lib/routes';
    final fileName = _classNameToSnakeCase(className);
    final outputPath = path.join(outputDir, '$fileName.dart');

    final content = _getRouterTemplate()
        .replaceAll('{{className}}', className)
        .replaceAll('{{littleName}}', _generateLittleName(className));

    await _writeFile(outputPath, content);
    return outputPath;
  }

  /// 生成完整页面模块（页面+控制器+变量）
  ///
  /// [className] 页面类名，如 'HomePage'
  /// [outputDir] 输出根目录，默认为 'lib/pages'
  ///
  /// 返回生成的文件路径列表
  static Future<List<String>> generatePageModule(String className,
      {String? outputDir}) async {
    outputDir ??= 'lib/pages';
    final snakeCaseName = _classNameToSnakeCase(className);
    final moduleDir = path.join(outputDir, snakeCaseName);
    final controllerDir = path.join(moduleDir, 'controller');
    final varsDir = path.join(moduleDir, 'vars');

    // 创建目录结构
    await Directory(moduleDir).create(recursive: true);
    await Directory(controllerDir).create(recursive: true);
    await Directory(varsDir).create(recursive: true);

    final generatedFiles = <String>[];

    // 生成页面文件
    final pagePath = path.join(moduleDir, '$className.dart');
    final pageContent = _getPageTemplate()
        .replaceAll('{{className}}', className)
        .replaceAll('{{littleName}}', _generateLittleName(className));
    await _writeFile(pagePath, pageContent);
    generatedFiles.add(pagePath);

    // 生成控制器文件
    final controllerPath =
        path.join(controllerDir, '${className}Controller.dart');
    final controllerContent = _getControllerTemplate()
        .replaceAll('{{className}}', '${className}Controller')
        .replaceAll(
            '{{littleName}}', '${_generateLittleName(className)}Controller');
    await _writeFile(controllerPath, controllerContent);
    generatedFiles.add(controllerPath);

    // 生成变量文件
    final varsPath = path.join(varsDir, '${className}Vars.dart');
    final varsContent = _getVarsTemplate()
        .replaceAll('{{className}}', '${className}Vars')
        .replaceAll('{{littleName}}', '${_generateLittleName(className)}Vars');
    await _writeFile(varsPath, varsContent);
    generatedFiles.add(varsPath);

    return generatedFiles;
  }

  /// 写入文件并创建必要的目录
  static Future<void> _writeFile(String filePath, String content) async {
    final file = File(filePath);
    final dir = file.parent;

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    await file.writeAsString(content);
    print('✅ Generated: $filePath');
  }

  /// 将类名转换为snake_case
  static String _classNameToSnakeCase(String className) {
    return className.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
      final char = match.group(0)!.toLowerCase();
      return match.start == 0 ? char : '_$char';
    });
  }

  /// 根据类名生成小驼峰命名
  static String _generateLittleName(String className) {
    if (className.isEmpty) return '';
    return className[0].toLowerCase() + className.substring(1);
  }

  /// 获取页面模板
  static String _getPageTemplate() {
    return '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_lib/base_lib.dart';

class {{className}} extends BasePage {
  const {{className}}({super.key});
  @override
  BasePageState<BasePage> createState() {
    return {{className}}State();
  }
}

class {{className}}State extends BasePageState<{{className}}> {
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
        child: Text("{{className}}"),
      ),
    );
  }
}''';
  }

  /// 获取控制器模板
  static String _getControllerTemplate() {
    return '''
import 'package:flutter_riverpod/flutter_riverpod.dart';

class {{className}}State{
    //{{className}}State({});
    //{{className}}State copyWith({}){
    //    return {{className}}State(
    //    );
    //}
}

final {{littleName}}Provider = StateNotifierProvider.autoDispose<{{className}}Controller, {{className}}State>((ref) {
    return {{className}}Controller();
});

class {{className}}Controller extends StateNotifier<{{className}}State>{
    {{className}}Controller() : super({{className}}State());
}''';
  }

  /// 获取变量模板
  static String _getVarsTemplate() {
    return '''
class {{className}}Vars {
   {{className}}Vars(){
   
   }
}''';
  }

  /// 获取路由模板
  static String _getRouterTemplate() {
    return '''
import 'package:get/get.dart';

class {{className}} { 
    // Router Names
    static const String homePage = "/homePage";

    static final routerPage = [
        GetPage(
            name: homePage, 
            page: () => HomePage(),
        ),
    ];
}''';
  }
}
