import 'dart:io';
import 'dart:convert';
import 'package:yaml/yaml.dart';

void main(List<String> arguments) async {
  print('🚀 Template Generator Started');

  // 读取配置文件
  final configFile = File('templates_config.yaml');
  if (!await configFile.exists()) {
    print('❌ Configuration file templates_config.yaml not found');
    exit(1);
  }

  final configContent = await configFile.readAsString();
  final config = loadYaml(configContent);

  // 处理每个类型的模板
  for (final category in config['templates'].keys) {
    final templates = config['templates'][category] as List;

    for (final template in templates) {
      await generateFromTemplate(
        category: category,
        fileName: template['fileName'],
        className: template['className'],
        templateFile: template['template'],
      );
    }
  }

  print('✅ All templates generated successfully!');
}

Future<void> generateFromTemplate({
  required String category,
  required String fileName,
  required String className,
  required String templateFile,
}) async {
  try {
    // 读取模板文件
    final templatePath = 'lib/src/templates/$templateFile';
    final template = File(templatePath);

    if (!await template.exists()) {
      print('❌ Template file not found: $templatePath');
      return;
    }

    var content = await template.readAsString();

    // 移除配置注释（如果有的话）
    content = _removeConfigComments(content);

    // 替换变量
    final littleName = _generateLittleName(className);
    content = content
        .replaceAll('{{className}}', className)
        .replaceAll('{{littleName}}', littleName);

    // 确定输出路径
    final outputPath = _getOutputPath(category, fileName);
    final outputDir =
        Directory(outputPath.substring(0, outputPath.lastIndexOf('/')));

    // 创建目录
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }

    // 写入文件
    final outputFile = File(outputPath);
    await outputFile.writeAsString(content);

    print('✅ Generated: $outputPath (Class: $className)');
  } catch (e) {
    print('❌ Error generating $fileName: $e');
  }
}

String _getOutputPath(String category, String fileName) {
  switch (category) {
    case 'pages':
      return 'lib/pages/$fileName.dart';
    case 'controllers':
      return 'lib/controllers/$fileName.dart';
    case 'vars':
      return 'lib/vars/$fileName.dart';
    case 'routes':
      return 'lib/routes/$fileName.dart';
    default:
      return 'lib/$fileName.dart';
  }
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
    // 跳过配置注释行
    if (trimmed.startsWith('// @')) {
      continue;
    }
    filteredLines.add(line);
  }

  return filteredLines.join('\n');
}
