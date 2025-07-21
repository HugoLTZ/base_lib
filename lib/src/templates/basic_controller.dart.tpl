// templates/basic_controller.dart.tpl

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

}