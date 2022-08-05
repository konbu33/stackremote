import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers.dart';

class CustomMouseCursor extends HookConsumerWidget {
  const CustomMouseCursor({Key? key}) : super(key: key);

  static const double radius = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(
        Providers.CustomMouseCursorOverlayerStateNotifierProvider.notifier);

    return
        // IgnorePointer(
        //   child:
        GestureDetector(
      onTap: () {
        notifier.changeOnLongPress(isOnLongPressing: false);
        notifier.updatePosition(const Offset(0, 0));
      },
      child: const Icon(CupertinoIcons.arrow_up_left),
      // ),
      // Container(
      //   height: radius,
      //   width: radius,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(radius),
      //     border: Border.all(
      //       color: const Color.fromRGBO(170, 170, 170, 0.6),
      //     ),
      //     color: const Color.fromRGBO(170, 170, 170, 0.8 - 0.4),
      //   ),
      // ),
    );
  }
}
