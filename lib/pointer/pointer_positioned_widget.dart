import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pointer_widget.dart';
import 'pointer_overlay_state.dart';

class PointerPositionedWidget extends HookConsumerWidget {
  const PointerPositionedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointerOverlayStateNotifierProvider);

    final top = state.displayPointerPosition.dy;
    final left = state.displayPointerPosition.dx;

    return Positioned(
      top: top,
      left: left,
      child: const PointerWidget(),
    );
  }
}
