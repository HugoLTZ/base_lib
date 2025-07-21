// templates/basic_controller.dart.tpl

class {{className}}State{

    {{className}}State({});

    {{className}}State copyWith({}){
        return {{className}}State(
        );
    }
}

final {{littleName}}Provider = StateNotifierProvider.autoDispose<{{className}}Controller, {{className}}State>((ref) {
})

class {{className}}Controller extends StateNotifier<{{className}}State>{

    {{className}}Controller() : super({{className}}State());

}