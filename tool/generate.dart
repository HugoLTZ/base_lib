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
    print('6. Exit');

    stdout.write('\nEnter your choice (1-6): ');
    final choice = stdin.readLineSync();

    if (choice == '6') {
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
  print('Types: page, controller, vars, router, module');
  print('');
  print('Examples:');
  print('  dart run tool/generate.dart page home_page HomePage');
  print(
      '  dart run tool/generate.dart controller user_controller UserController');
  print('  dart run tool/generate.dart module LoginPage');
  print('');
  print('Or run without arguments for interactive mode:');
  print('  dart run tool/generate.dart');
}
