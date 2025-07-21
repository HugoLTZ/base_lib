// templates/basic_page.dart.tpl

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}