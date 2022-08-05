import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/custom_mouse_cursor/custom_mouse_cursor_overlayer_state.dart';

class CustomMouseCursorOverlayerStateNotifier
    extends StateNotifier<CustomMouseCursorOerlayerState> {
  CustomMouseCursorOverlayerStateNotifier()
      : super(CustomMouseCursorOerlayerState.initial());

  void updatePosition(Offset offset) {
    state = state.copyWith(cursorPosition: offset);
    //  state = state.copyWith(
    //     pointerPosition: offset, positionDx: offset.dx, positionDy: offset.dy);
  }

  void changeOnLongPress({required bool isOnLongPressing}) {
    state = state.copyWith(isOnLongPressing: isOnLongPressing);
  }

  // void exit() {
  //   state = state.copyWith(cursorPosition: Offset.zero);
  //   // state = state.copyWith(positionDx: 0, positionDy: 0);
  // }
}
