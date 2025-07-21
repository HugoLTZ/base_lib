import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  BasePageState createState();
}

abstract class BasePageState<T extends BasePage> extends State<T> {
  String? get title => null;
  bool get showAppBar => true;

  @override
  void initState() {
    super.initState();
    // 初始化操作
    onInit();
  }

  @override
  void dispose() {
    // 清理操作
    onDispose();
    super.dispose();
  }

  // 初始化方法，可在子类中重写
  void onInit() {}

  // 销毁方法，可在子类中重写
  void onDispose() {}

  // 主体内容方法，必须在子类中实现
  Widget buildBody(BuildContext context, WidgetRef ref);

  @override
  Widget build(BuildContext context) {
    // 统一设置状态栏样式为深色内容
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        // 状态栏背景色为白色
        statusBarColor: Colors.white,
        // 状态栏内容（时间、电池等图标）为深色
        statusBarIconBrightness: Brightness.dark,
        // iOS状态栏内容为深色
        statusBarBrightness: Brightness.light,
        // 导航栏背景色为白色
        systemNavigationBarColor: Colors.white,
        // 导航栏按钮为深色
        systemNavigationBarIconBrightness: Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(title ?? 'Default Title'),
              // 确保AppBar也使用统一的状态栏样式
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: Colors.white,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
            )
          : null,
      body: SafeArea(
        top: false,
        child: Consumer(
          builder: (context, ref, child) {
            return Container(
              color: Colors.white,
              child: buildBody(context, ref),
            );
          },
        ),
      ),
    );
  }

  // 获取页面标题
  String getTitle() => 'Base Page';
}
