import 'dart:io';

void main(List<String> arguments) async {
  print('🎯 Interactive Template Generator');
  print('===================================');

  // 处理命令行参数
  if (arguments.isNotEmpty) {
    await handleCommandArgs(arguments);
    return;
  }

  // 交互模式
  await interactiveMode();
}

Future<void> handleCommandArgs(List<String> args) async {
  if (args.length < 2) {
    printUsage();
    return;
  }

  final type = args[0];

  if (type == 'module') {
    // 生成完整页面模块
    if (args.length < 2) {
      print('❌ Module generation requires className');
      printUsage();
      return;
    }
    final className = args[1];
    await generatePageModule(className);
  } else if (type == 'http_module') {
    // 生成完整HTTP模块
    if (args.length < 2) {
      print('❌ HTTP module generation requires projectName');
      printUsage();
      return;
    }
    final projectName = args[1];
    await generateHttpModule(projectName);
  } else {
    // 单个文件生成
    if (args.length < 3) {
      printUsage();
      return;
    }
    final fileName = args[1];
    final className = args[2];
    await generateTemplate(type, fileName, className);
  }
}

Future<void> interactiveMode() async {
  while (true) {
    print('\n📋 Select template type:');
    print('1. Page');
    print('2. Controller');
    print('3. Vars');
    print('4. Router');
    print('5. Page Module (页面+控制器+变量)');
    print('6. HTTP API');
    print('7. HTTP Exception');
    print('8. HTTP Interceptor');
    print('9. HTTP Request');
    print('10. HTTP Stream Request');
    print('11. HTTP Module (完整HTTP模块)');
    print('12. Exit');

    stdout.write('\nEnter your choice (1-12): ');
    final choice = stdin.readLineSync();

    if (choice == '12') {
      print('👋 Goodbye!');
      break;
    }

    if (choice == '5') {
      // 生成完整页面模块
      stdout.write('📝 Enter class name (e.g., LoginPage): ');
      final className = stdin.readLineSync();

      if (className == null || className.trim().isEmpty) {
        print('❌ Class name cannot be empty.');
        continue;
      }

      await generatePageModule(className.trim());
    } else if (choice == '11') {
      // 生成完整HTTP模块
      stdout.write('📝 Enter project name (e.g., MyProject): ');
      final projectName = stdin.readLineSync();

      if (projectName == null || projectName.trim().isEmpty) {
        print('❌ Project name cannot be empty.');
        continue;
      }

      await generateHttpModule(projectName.trim());
    } else {
      // 单个文件生成
      final type = _getTypeFromChoice(choice);
      if (type == null) {
        print('❌ Invalid choice. Please try again.');
        continue;
      }

      stdout.write('📝 Enter file name (without .dart): ');
      final fileName = stdin.readLineSync();

      if (fileName == null || fileName.trim().isEmpty) {
        print('❌ File name cannot be empty.');
        continue;
      }

      stdout.write('🏷️ Enter class name (or press Enter to auto-generate): ');
      final classNameInput = stdin.readLineSync();

      final className =
          (classNameInput == null || classNameInput.trim().isEmpty)
              ? _generateClassName(fileName.trim())
              : classNameInput.trim();

      await generateTemplate(type, fileName.trim(), className);
    }

    stdout.write('\n🔄 Generate another template? (y/n): ');
    final continueChoice = stdin.readLineSync();
    if (continueChoice?.toLowerCase() != 'y') {
      print('👋 Goodbye!');
      break;
    }
  }
}

String? _getTypeFromChoice(String? choice) {
  switch (choice) {
    case '1':
      return 'page';
    case '2':
      return 'controller';
    case '3':
      return 'vars';
    case '4':
      return 'router';
    case '6':
      return 'http_api';
    case '7':
      return 'http_exception';
    case '8':
      return 'http_interceptor';
    case '9':
      return 'http_request';
    case '10':
      return 'http_stream_request';
    default:
      return null;
  }
}

/// 生成完整的页面模块（页面+控制器+变量）
Future<void> generatePageModule(String className) async {
  try {
    print('\n🚀 Generating page module for: $className');

    // 转换命名
    final snakeCaseName = _classNameToSnakeCase(className);
    final littleName = _generateLittleName(className);

    print('📁 Module directory: lib/pages/$snakeCaseName/');

    // 创建目录结构
    final moduleDir = 'lib/pages/$snakeCaseName';
    final controllerDir = '$moduleDir/controller';
    final varsDir = '$moduleDir/vars';

    await Directory(moduleDir).create(recursive: true);
    await Directory(controllerDir).create(recursive: true);
    await Directory(varsDir).create(recursive: true);

    // 生成页面文件
    await _generateModuleFile(
      templateFile: 'basic_page.dart.tpl',
      outputPath: '$moduleDir/$className.dart',
      className: className,
      littleName: littleName,
    );

    // 生成控制器文件
    await _generateModuleFile(
      templateFile: 'basic_controller.dart.tpl',
      outputPath: '$controllerDir/$className.dart',
      className: '${className}Controller',
      littleName: '${littleName}Controller',
    );

    // 生成变量文件
    await _generateModuleFile(
      templateFile: 'basic_vars.dart.tpl',
      outputPath: '$varsDir/$className.dart',
      className: className,
      littleName: littleName,
    );

    print('\n✅ Page module generated successfully!');
    print('📂 Files created:');
    print('   - $moduleDir/$className.dart');
    print('   - $controllerDir/$className.dart');
    print('   - $varsDir/$className.dart');
  } catch (e) {
    print('❌ Error generating page module: $e');
  }
}

/// 生成完整的HTTP模块（API+异常+拦截器+请求）
Future<void> generateHttpModule(String projectName) async {
  try {
    print('\n🚀 Generating HTTP module for: $projectName');

    // 创建HTTP目录结构
    final httpDir = 'lib/src/http';
    final apiDir = '$httpDir/api';
    final exceptionDir = '$httpDir/exception';
    final interceptorDir = '$httpDir/interceptor';
    final requestDir = '$httpDir/request';

    await Directory(apiDir).create(recursive: true);
    await Directory(exceptionDir).create(recursive: true);
    await Directory(interceptorDir).create(recursive: true);
    await Directory(requestDir).create(recursive: true);

    // 生成API文件
    await _generateHttpModuleFile(
      templateFile: 'http/api/RequestApi.dart.tpl',
      outputPath: '$apiDir/${projectName}Api.dart',
      className: '${projectName}Api',
    );

    // 生成异常处理文件
    await _generateHttpModuleFile(
      templateFile: 'http/exception/HttpException.dart.tpl',
      outputPath: '$exceptionDir/${projectName}Exception.dart',
      className: '${projectName}Exception',
    );

    // 生成拦截器文件
    await _generateHttpModuleFile(
      templateFile: 'http/interceptor/PrettyDioLogger.dart.tpl',
      outputPath: '$interceptorDir/PrettyDioLogger.dart',
      className: 'PrettyDioLogger',
    );

    await _generateHttpModuleFile(
      templateFile: 'http/interceptor/RequestHeadInterceptor.dart.tpl',
      outputPath: '$interceptorDir/RequestHeadInterceptor.dart',
      className: 'RequestHeadInterceptor',
    );

    // 生成请求文件
    await _generateHttpModuleFile(
      templateFile: 'http/request/HttpRequest.dart.tpl',
      outputPath: '$requestDir/${projectName}Request.dart',
      className: '${projectName}Request',
    );

    print('\n✅ HTTP module generated successfully!');
    print('📂 Files created:');
    print('   - $apiDir/${projectName}Api.dart');
    print('   - $exceptionDir/${projectName}Exception.dart');
    print('   - $interceptorDir/PrettyDioLogger.dart');
    print('   - $interceptorDir/RequestHeadInterceptor.dart');
    print('   - $requestDir/${projectName}Request.dart');
    print('   - $requestDir/Stream${projectName}Request.dart');
  } catch (e) {
    print('❌ Error generating HTTP module: $e');
  }
}

/// 生成模块中的单个文件
Future<void> _generateModuleFile({
  required String templateFile,
  required String outputPath,
  required String className,
  required String littleName,
}) async {
  final templatePath = 'lib/src/templates/$templateFile';
  final template = File(templatePath);

  if (!await template.exists()) {
    print('❌ Template file not found: $templatePath');
    return;
  }

  var content = await template.readAsString();

  // 移除配置注释
  content = _removeConfigComments(content);

  // 替换变量
  content = content
      .replaceAll('{{className}}', className)
      .replaceAll('{{littleName}}', littleName);

  // 写入文件
  final outputFile = File(outputPath);
  await outputFile.writeAsString(content);
}

/// 生成HTTP模块中的单个文件
Future<void> _generateHttpModuleFile({
  required String templateFile,
  required String outputPath,
  required String className,
}) async {
  final templatePath = 'lib/src/templates/$templateFile';
  final template = File(templatePath);

  if (!await template.exists()) {
    print('❌ Template file not found: $templatePath');
    return;
  }

  var content = await template.readAsString();

  // 移除配置注释
  content = _removeConfigComments(content);

  // 替换变量
  final littleName = _generateLittleName(className);
  content = content
      .replaceAll('{{className}}', className)
      .replaceAll('{{littleName}}', littleName);

  // 写入文件
  final outputFile = File(outputPath);
  await outputFile.writeAsString(content);
}

/// 将类名转换为snake_case
String _classNameToSnakeCase(String className) {
  // 处理大驼峰命名转下划线命名
  return className.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
    final char = match.group(0)!.toLowerCase();
    return match.start == 0 ? char : '_$char';
  });
}

Future<void> generateTemplate(
    String type, String fileName, String className) async {
  try {
    // 确定模板文件
    final templateFile = _getTemplateFile(type);
    final templatePath = 'lib/src/templates/$templateFile';
    final template = File(templatePath);

    if (!await template.exists()) {
      print('❌ Template file not found: $templatePath');
      return;
    }

    var content = await template.readAsString();

    // 移除配置注释
    content = _removeConfigComments(content);

    // 替换变量
    final littleName = _generateLittleName(className);
    content = content
        .replaceAll('{{className}}', className)
        .replaceAll('{{littleName}}', littleName);

    // 确定输出路径
    final outputPath = _getOutputPath(type, fileName);
    final outputDir =
        Directory(outputPath.substring(0, outputPath.lastIndexOf('/')));

    // 创建目录
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }

    // 写入文件
    final outputFile = File(outputPath);
    await outputFile.writeAsString(content);

    print('✅ Generated: $outputPath');
    print('📄 Class: $className');
  } catch (e) {
    print('❌ Error generating $fileName: $e');
  }
}

String _getTemplateFile(String type) {
  switch (type) {
    case 'page':
      return 'basic_page.dart.tpl';
    case 'controller':
      return 'basic_controller.dart.tpl';
    case 'vars':
      return 'basic_vars.dart.tpl';
    case 'router':
      return 'router.dart.tpl';
    case 'http_api':
      return 'http/api/RequestApi.dart.tpl';
    case 'http_exception':
      return 'http/exception/HttpException.dart.tpl';
    case 'http_interceptor':
      return 'http/interceptor/PrettyDioLogger.dart.tpl';
    case 'http_request':
      return 'http/request/HttpRequest.dart.tpl';
    case 'http_stream_request':
      return 'http/request/StreamHttpRequest.dart.tpl';
    default:
      return 'basic_page.dart.tpl';
  }
}

String _getOutputPath(String type, String fileName) {
  switch (type) {
    case 'page':
      return 'lib/pages/$fileName.dart';
    case 'controller':
      return 'lib/controllers/$fileName.dart';
    case 'vars':
      return 'lib/vars/$fileName.dart';
    case 'router':
      return 'lib/routes/$fileName.dart';
    case 'http_api':
      return 'lib/http/api/$fileName.dart';
    case 'http_exception':
      return 'lib/http/exception/$fileName.dart';
    case 'http_interceptor':
      return 'lib/http/interceptor/$fileName.dart';
    case 'http_request':
      return 'lib/http/request/$fileName.dart';
    case 'http_stream_request':
      return 'lib/http/request/$fileName.dart';
    default:
      return 'lib/$fileName.dart';
  }
}

String _generateClassName(String fileName) {
  final parts =
      fileName.split(RegExp(r'[_-]')).where((part) => part.isNotEmpty).toList();

  return parts
      .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
      .join('');
}

String _generateLittleName(String className) {
  if (className.isEmpty) return '';
  return className[0].toLowerCase() + className.substring(1);
}

String _removeConfigComments(String content) {
  final lines = content.split('\n');
  final filteredLines = <String>[];

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.startsWith('// @')) {
      continue;
    }
    filteredLines.add(line);
  }

  return filteredLines.join('\n');
}

void printUsage() {
  print('Usage:');
  print('  Single file generation:');
  print('    dart run tool/generate.dart [type] [fileName] [className]');
  print('');
  print('  Page module generation:');
  print('    dart run tool/generate.dart module [className]');
  print('');
  print('  HTTP module generation:');
  print('    dart run tool/generate.dart http_module [projectName]');
  print('');
  print(
      'Types: page, controller, vars, router, module, http_api, http_exception, http_interceptor, http_request, http_stream_request, http_module');
  print('');
  print('Examples:');
  print('  dart run tool/generate.dart page home_page HomePage');
  print(
      '  dart run tool/generate.dart controller user_controller UserController');
  print('  dart run tool/generate.dart module LoginPage');
  print('  dart run tool/generate.dart http_api request_api RequestApi');
  print('  dart run tool/generate.dart http_module MyProject');
  print('');
  print('Or run without arguments for interactive mode:');
  print('  dart run tool/generate.dart');
}
