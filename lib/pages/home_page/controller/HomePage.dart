// templates/basic_controller.dart.tpl

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageControllerState {
  // HomePageControllerState({});

  // HomePageControllerState copyWith({}){
  //     return HomePageControllerState(
  //     );
  // }
}

final homePageControllerProvider = StateNotifierProvider.autoDispose<
    HomePageControllerController, HomePageControllerState>((ref) {
  return HomePageControllerController();
});

class HomePageControllerController
    extends StateNotifier<HomePageControllerState> {
  HomePageControllerController() : super(HomePageControllerState());
}
