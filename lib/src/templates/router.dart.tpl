//templates/router.dart.tpl

import 'package:get/get.dart';

class Router { 
    // Router Names
    static const String homePage = "/homePage";

    static final routerPage = [
        GetPage(
            name: homePage, 
            page: () => HomePage(),
        ),
    ];
}