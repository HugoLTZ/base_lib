// templates/basic_page.dart.tpl

import 'package:base_lib/src/page/BasePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends BasePage {
  const HomePage({super.key});
  @override
  BasePageState<BasePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends BasePageState<HomePage> {
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
        child: Text("HomePage"),
      ),
    );
  }
}
