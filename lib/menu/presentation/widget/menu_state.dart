import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'menu_state.freezed.dart';

enum OperationMenu {
  start,
  changePassword,
  user,
}

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class MenuState with _$MenuState {
  const factory MenuState({
    required OperationMenu currentMmenuItem,
  }) = _MenuState;

  factory MenuState.create() => const MenuState(
        currentMmenuItem: OperationMenu.start,
      );
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class MenuStateNotifier extends StateNotifier<MenuState> {
  MenuStateNotifier() : super(MenuState.create()) {
    initial();
  }

  // initial
  void initial() {
    state = MenuState.create();
  }

  void changeCurrentMenu(OperationMenu menuItem) {
    state = state.copyWith(currentMmenuItem: menuItem);
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final menuStateNotifierProvider =
    StateNotifierProvider<MenuStateNotifier, MenuState>((ref) {
  return MenuStateNotifier();
});


// // --------------------------------------------------
// //
// //  typedef Provider
// //
// // --------------------------------------------------
// typedef MenuStateNotifierProvider
//     = StateNotifierProvider<MenuStateNotifier, MenuState>;

// // --------------------------------------------------
// //
// //  StateNotifierProviderCreator
// //
// // --------------------------------------------------
// MenuStateNotifierProvider menuStateNotifierProviderCreator() {
//   return StateNotifierProvider<MenuStateNotifier, MenuState>((ref) {
//     return MenuStateNotifier();
//   });
// }

// // --------------------------------------------------
// //
// //  StateNotifierProviderList
// //
// // --------------------------------------------------
// class MenuStateNotifierProviderList {
//   static final menuStateNotifierProvider = menuStateNotifierProviderCreator();
// }
