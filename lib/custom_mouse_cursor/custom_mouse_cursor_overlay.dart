import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'custom_mouse_cursor_overlayer_state_notifier.dart';
import 'custom_mouse_cursor_positioned.dart';

class CustomMouseCursorOverlayer extends HookConsumerWidget {
  const CustomMouseCursorOverlayer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customMouseCursorOverlayerStateNotifierProvider);

    final notifier =
        ref.read(customMouseCursorOverlayerStateNotifierProvider.notifier);

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      // onHover: (event) {
      //   notifier.updatePosition(event.position);
      // },
      // onExit: (_) => notifier.exit(),
      child: GestureDetector(
        onLongPressStart: (event) {
          notifier.changeOnLongPress(isOnLongPressing: true);
          notifier.updatePosition(event.globalPosition);
        },
        onLongPressEnd: (event) {
          // notifier.changeOnLongPress(isOnLongPressing: false);
          // notifier.updatePosition(const Offset(0, 0));
        },
        onLongPressMoveUpdate: (event) {
          notifier.updatePosition(event.globalPosition);
        },
        child: Stack(
          children: [
            child,
            // ↓マウスカーソル↓
            // const CustomMouseCursor(),
            if (state.isOnLongPressing) const CustomMouseCursorPositioned(),
          ],
        ),
      ),
    );
  }
}
