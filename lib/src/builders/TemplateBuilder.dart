import 'dart:async';

import 'package:build/build.dart';

/// Builder工厂函数
Builder templateBuilder(BuilderOptions options) => Templatebuilder();

class Templatebuilder extends Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final input = buildStep.inputId;
    final content = await buildStep.readAsString(input);

    // 解析模板配置
    final config = _parseTemplateConfig(content);

    // 从文件名提取基础名称（移除.dart.tpl扩展名）
    final fullFileName = input.pathSegments.last;
    final baseName = fullFileName.replaceAll('.dart.tpl', '');

    // 使用配置中的文件名，如果没有配置则使用默认值
    final outputFileName = config['fileName'] ?? baseName;
    final configClassName = config['className'];

    // 生成类名
    final className = configClassName ?? _generateClassName(outputFileName);
    final littleName = _generateLittleName(className);

    // 替换模板变量，并移除配置注释
    final outputContent = _removeConfigComments(content)
        .replaceAll('{{className}}', className)
        .replaceAll('{{littleName}}', littleName);

    // 根据模板类型生成不同的输出路径
    final outputPath = _generateOutputPath(outputFileName, fullFileName);
    final outputId = AssetId(input.package, outputPath);

    await buildStep.writeAsString(outputId, outputContent);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart.tpl': ['.dart']
      };

  /// 解析模板文件顶部的配置注释
  /// 支持格式：// @fileName: home_page
  ///         // @className: HomePage
  Map<String, String> _parseTemplateConfig(String content) {
    final config = <String, String>{};
    final lines = content.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      // 如果遇到非注释行，停止解析配置
      if (!trimmed.startsWith('//') && trimmed.isNotEmpty) {
        break;
      }

      // 解析配置注释
      if (trimmed.startsWith('// @')) {
        final configLine = trimmed.substring(4); // 移除 "// @"
        final colonIndex = configLine.indexOf(':');
        if (colonIndex > 0) {
          final key = configLine.substring(0, colonIndex).trim();
          final value = configLine.substring(colonIndex + 1).trim();
          config[key] = value;
        }
      }
    }

    return config;
  }

  /// 移除模板文件中的配置注释
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

  /// 根据文件名生成类名（大驼峰命名）
  String _generateClassName(String baseName) {
    // 按下划线或连字符分割
    final parts = baseName
        .split(RegExp(r'[_-]'))
        .where((part) => part.isNotEmpty)
        .toList();

    // 转换为大驼峰命名
    return parts
        .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join('');
  }

  /// 根据类名生成小驼峰命名
  String _generateLittleName(String className) {
    if (className.isEmpty) return '';
    return className[0].toLowerCase() + className.substring(1);
  }

  /// 根据模板类型和文件名生成输出路径
  String _generateOutputPath(String fileName, String fullFileName) {
    // 根据模板类型确定输出目录和文件名
    if (fullFileName.contains('controller')) {
      return 'lib/controllers/${fileName}.dart';
    } else if (fullFileName.contains('page')) {
      return 'lib/pages/${fileName}.dart';
    } else if (fullFileName.contains('vars')) {
      return 'lib/vars/${fileName}.dart';
    } else if (fullFileName.contains('router')) {
      return 'lib/routes/${fileName}.dart';
    } else {
      // 默认输出到lib目录
      return 'lib/${fileName}.dart';
    }
  }
}
