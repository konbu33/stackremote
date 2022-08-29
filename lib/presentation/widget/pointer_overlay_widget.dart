import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pointer_overlay_state.dart';
import 'pointer_positioned_widget.dart';

class PointerOverlayWidget extends HookConsumerWidget {
  const PointerOverlayWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointerOverlayStateNotifierProvider);

    final notifier = ref.read(pointerOverlayStateNotifierProvider.notifier);

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        onLongPressStart: (event) {
          notifier.changeOnLongPress(isOnLongPressing: true);
          notifier.updatePosition(event.globalPosition);
        },
        onLongPressEnd: (event) {},
        onLongPressMoveUpdate: (event) {
          notifier.updatePosition(event.globalPosition);
        },
        child: Stack(
          children: [
            child,
            if (state.isOnLongPressing) const PointerPositionedWidget(),
          ],
        ),
      ),
    );
  }
}
