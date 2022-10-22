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
        // ロングタップすることで、ポイン表示開始
        onLongPressStart: (event) {
          notifier.changeOnLongPress(isOnLongPressing: true);
          notifier.updatePosition(event.localPosition);
        },

        // ロングタップ中は、ポイン表示
        onLongPressMoveUpdate: (event) {
          notifier.updatePosition(event.localPosition);
        },

        child: Container(
          // Container内にポインタが表示される。
          // ContainerのサイズをScaffoldの範囲に合わせるためにcolor指指。
          // この点は改善できそう。
          color: Colors.transparent,
          child: Stack(
            children: [
              child,
              // childの上位レイヤーにポインを表示
              if (state.isOnLongPressing) const PointerPositionedWidget(),

              // debug: ポインタの位置を表示
              Text(
                  "x:${(state.pointerPosition.dx.round())}, y:${state.pointerPosition.dy.round()}"),
            ],
          ),
        ),
      ),
    );
  }
}
