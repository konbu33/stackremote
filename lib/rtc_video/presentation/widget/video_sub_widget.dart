import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nested/nested.dart';

import '../../../common/common.dart';

// --------------------------------------------------
//
//   VideoSubState
//
// --------------------------------------------------
class VideoSubState {
  final remotePreviewIsDragStartProvider = StateProvider((ref) => false);

  final remotePreviewPositionProvider =
      StateProvider((ref) => const Offset(300, 300));

  final remotePreviewSizeProvider =
      StateProvider((ref) => const Size(100, 120));
}

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
    final videoSubState = VideoSubState();

    return Nested(
      children: [
        PositionedWidget(videoSubState: videoSubState),
        DraggableWidget(videoSubState: videoSubState),
        ClippedVideoWidget(videoSubState: videoSubState),
      ],
      child: child,
    );
  }
}

// --------------------------------------------------
//
//   PositionedWidget
//
// --------------------------------------------------
class PositionedWidget extends SingleChildStatelessWidget {
  const PositionedWidget({super.key, super.child, required this.videoSubState});

  final VideoSubState videoSubState;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer(
        child: child,
        builder: (context, ref, child) {
          final remotePreviewPosition =
              ref.watch(videoSubState.remotePreviewPositionProvider);

          return Positioned(
            top: remotePreviewPosition.dy,
            left: remotePreviewPosition.dx,
            child: Column(
              children: [
                child ?? const Text("no child"),
                Text("$remotePreviewPosition"),
              ],
            ),
          );
        });
  }
}

// --------------------------------------------------
//
//   DraggableWidget
//
// --------------------------------------------------

class DraggableWidget extends SingleChildStatelessWidget {
  const DraggableWidget({super.key, super.child, required this.videoSubState});

  final VideoSubState videoSubState;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer(
        child: child,
        builder: (context, ref, child) {
          return Draggable(
            onDragStarted: () {
              ref
                  .read(videoSubState.remotePreviewIsDragStartProvider.notifier)
                  .update((state) => true);
            },
            onDragUpdate: (draggableDetails) {
              ref
                  .read(videoSubState.remotePreviewPositionProvider.notifier)
                  .update((state) {
                logger.d(
                    "draggableDetails state: $state, delta: ${draggableDetails.delta}, local: ${draggableDetails.localPosition}");

                return state + draggableDetails.delta;
              });
            },
            onDragEnd: (draggableDetails) {
              ref
                  .read(videoSubState.remotePreviewIsDragStartProvider.notifier)
                  .update((state) => false);
            },
            feedback: child ?? const Text("no child"),
            child: ref.watch(videoSubState.remotePreviewIsDragStartProvider)
                ? const SizedBox()
                : child ?? const Text("no child"),
          );
        });
  }
}

// --------------------------------------------------
//
//   ClippedVideo
//
// --------------------------------------------------

class ClippedVideoWidget extends SingleChildStatelessWidget {
  const ClippedVideoWidget(
      {super.key, super.child, required this.videoSubState});

  final VideoSubState videoSubState;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer(
        child: child,
        builder: (context, ref, child) {
          final remotePreviewSize =
              ref.watch(videoSubState.remotePreviewSizeProvider);

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
