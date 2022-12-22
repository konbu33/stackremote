import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DraggableWidget extends StatelessWidget {
  const DraggableWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final opacityProvider = StateProvider.autoDispose((ref) => 1.0);

    return Consumer(
        child: child,
        builder: (context, ref, child) {
          //

          final opacityWrapChild =
              Opacity(opacity: ref.watch(opacityProvider), child: child);

          return Draggable(
            data: 0,
            onDragStarted: () {
              ref.read(opacityProvider.notifier).update((state) => 0.0);
            },
            onDragEnd: (draggableDetails) {
              ref.read(opacityProvider.notifier).update((state) => 1.0);
            },
            feedback: opacityWrapChild,
            childWhenDragging: opacityWrapChild,
            child: opacityWrapChild,
          );
        });
  }
}
