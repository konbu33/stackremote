import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nested/nested.dart';

import 'video_sub_layer_widget.dart';

// --------------------------------------------------
//
//   VideoSubWidget
//
// --------------------------------------------------
class VideoSubWidget extends StatelessWidget {
  const VideoSubWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    //

    return child;

    // return Nested(
    //   children: const [
    //     ClippedVideoWidget(),
    //     DraggableWidget(),
    //   ],
    //   child: child,
    // );
  }
}

// --------------------------------------------------
//
//   DraggableWidget
//
// --------------------------------------------------

final opacityProvider = StateProvider((ref) => 1.0);
final visibilityProvider = StateProvider((ref) => true);

class DraggableWidget extends SingleChildStatelessWidget {
  const DraggableWidget({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer(
        child: child,
        builder: (context, ref, child) {
          //

          final newChild = Visibility(
            visible: ref.watch(visibilityProvider),
            maintainState: true,
            maintainSize: true,
            maintainAnimation: true,
            child: child ?? const Text("no child"),
          );

          // final newChild = Opacity(
          //     opacity: ref.watch(opacityProvider),
          //     child: child); //?? const Text("no child");

          return Draggable(
            data: 0,
            onDragStarted: () {
              // ref.read(opacityProvider.notifier).update((state) => 0.0);
              ref.read(visibilityProvider.notifier).update((state) => false);
            },
            // onDragCompleted: () {
            //   //
            // },
            onDragEnd: (draggableDetails) {
              // ref.read(opacityProvider.notifier).update((state) => 1.0);
              ref.read(visibilityProvider.notifier).update((state) => true);
            },
            feedback: newChild,
            childWhenDragging: newChild,
            child: newChild,
          );
        });
  }
}

// --------------------------------------------------
//
//   ClippedVideo
//
// --------------------------------------------------
final remotePreviewSizeProvider = StateProvider((ref) => const Size(100, 120));

class ClippedVideoWidget extends SingleChildStatelessWidget {
  const ClippedVideoWidget({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer(
        child: child,
        builder: (context, ref, child) {
          final remotePreviewSize = ref.watch(remotePreviewSizeProvider);

          return Container(
            width: remotePreviewSize.width,
            height: remotePreviewSize.height,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: Colors.white24,
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: child,
            ),
          );
        });
  }
}

class DragTargetWidget extends HookConsumerWidget {
  const DragTargetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dragTargetTopLeft = DragTarget<int>(
      builder: (context, candidateData, rejectedData) {
        return Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: const Text("dragTargetTopLeft"));
      },
      onAccept: (data) {
        ref
            .read(videoSubLayerAlignmentProvider.notifier)
            .update((state) => AlignmentDirectional.topStart);
      },
    );

    final dragTargetTopRight = DragTarget<int>(
      builder: (context, candidateData, rejectedData) {
        return Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: const Text("dragTargetTopRight"));
      },
      onAccept: (data) {
        ref
            .read(videoSubLayerAlignmentProvider.notifier)
            .update((state) => AlignmentDirectional.topEnd);
      },
    );

    final dragTargetBottomLeft = DragTarget<int>(
      builder: (context, candidateData, rejectedData) {
        return Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: const Text("dragTargetBottomLeft"));
      },
      onAccept: (data) {
        ref
            .read(videoSubLayerAlignmentProvider.notifier)
            .update((state) => AlignmentDirectional.bottomStart);
      },
    );

    final dragTargetBottomRight = DragTarget<int>(
      builder: (context, candidateData, rejectedData) {
        return Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: const Text("dragTargetBottomRight"));
      },
      onAccept: (data) {
        ref
            .read(videoSubLayerAlignmentProvider.notifier)
            .update((state) => AlignmentDirectional.bottomEnd);
      },
    );

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: dragTargetTopLeft),
              Expanded(child: dragTargetTopRight),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: dragTargetBottomLeft),
              Expanded(child: dragTargetBottomRight),
            ],
          ),
        ),
      ],
    );
  }
}
