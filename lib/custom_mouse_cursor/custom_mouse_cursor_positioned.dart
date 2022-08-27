import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'custom_mouse_cursor.dart';
import 'custom_mouse_cursor_overlayer_state_notifier.dart';

class CustomMouseCursorPositioned extends HookConsumerWidget {
  const CustomMouseCursorPositioned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customMouseCursorOverlayerStateNotifierProvider);
    // print(" y : ${state.positionDy - CustomMouseCursor.radius / 2}");
    // print(" x : ${state.positionDx - CustomMouseCursor.radius / 2}");

    print(" y : ${state.cursorPosition.dy - CustomMouseCursor.radius / 2}");
    print(" x : ${state.cursorPosition.dx - CustomMouseCursor.radius / 2}");

    return Positioned(
      top: state.cursorPosition.dy - CustomMouseCursor.radius / 2,
      left: state.cursorPosition.dx - CustomMouseCursor.radius / 2,
      // top: state.positionDy - CustomMouseCursor.radius / 2,
      // left: state.positionDx - CustomMouseCursor.radius / 2,
      child: const CustomMouseCursor(),
    );

    //  return Align(
    //   top: state.positionDy - CustomMouseCursor.radius / 2,
    //   left: state.positionDx - CustomMouseCursor.radius / 2,
    //   child: const CustomMouseCursor(),
    // );
  }
}
