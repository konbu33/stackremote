import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pointer_widget.dart';
import 'pointer_overlay_state.dart';

class PointerPositionedWidget extends HookConsumerWidget {
  const PointerPositionedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const pointerRadiusHalf = PointerWidget.radius / 2;
    final state = ref.watch(pointerOverlayStateNotifierProvider);

    // print(
    //     " x : ${state.pointerPosition.dx - pointerRadiusHalf}, y : ${state.pointerPosition.dy - pointerRadiusHalf} ");

    return Positioned(
      top: state.pointerPosition.dy - pointerRadiusHalf,
      left: state.pointerPosition.dx - pointerRadiusHalf,
      child: const PointerWidget(),
    );
  }
}
