import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pointer_overlay_state.dart';

class PointerWidget extends HookConsumerWidget {
  const PointerWidget({Key? key}) : super(key: key);

  static const double radius = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(pointerOverlayStateNotifierProvider.notifier);

    return GestureDetector(
      onTap: () {
        notifier.changeOnLongPress(isOnLongPressing: false);
        notifier.updatePosition(const Offset(0, 0));
      },
      child: const Icon(CupertinoIcons.arrow_up_left),
    );
  }
}
