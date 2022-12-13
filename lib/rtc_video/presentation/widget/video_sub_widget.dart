import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nested/nested.dart';

import '../../../common/common.dart';
import 'video_main_widget.dart';

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
    // return ClippedVideoWidget(child: DraggableWidget(child: child));
    // return Nested(
    //   children: const [
    //     ClippedVideoWidget(),
    //     DraggableWidget(),
    //   ],
    //   child: child,
    //   // Container(
    //   //   color: Colors.blue,
    //   //   height: 100,
    //   //   width: 200,
    //   //   child: Column(children: [
    //   //     Text("${ref.watch(remotePreviewIsDragStartProvider)}",
    //   //         style: textStyle),
    //   //     Text("${ref.watch(videoSubLayerAlignmentProvider)}",
    //   //         style: textStyle),
    //   //   ]),
    //   // ),
    // );

    // return Nested(
    //   children: [
    //     // PositionedWidget(videoSubState: videoSubState),
    //     DraggableWidget(videoSubState: videoSubState),
    //     ClippedVideoWidget(videoSubState: videoSubState),
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

final remotePreviewIsDragStartProvider = StateProvider((ref) => false);

class DraggableWidget extends SingleChildStatelessWidget {
  const DraggableWidget({super.key, super.child, required this.rtcVideoUid});

  final int rtcVideoUid;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Consumer(
        child: child,
        builder: (context, ref, child) {
          return Draggable(
            // data: rtcVideoUid,
            onDragStarted: () {
              ref
                  .read(remotePreviewIsDragStartProvider.notifier)
                  .update((state) => true);
            },
            // onDragCompleted: () {
            //   //
            //   // final videoSubLayerAlignment =
            //   //     ref.watch(videoSubLayerAlignmentProvider);
            //   // logger.d("videoSubLayerAlignment: $videoSubLayerAlignment");
            // },
            onDragEnd: (draggableDetails) {
              ref
                  .read(remotePreviewIsDragStartProvider.notifier)
                  .update((state) => false);
            },
            feedback: child ?? const Text("no child"),
            // feedback: const Text("no child"),
            child: ref.watch(remotePreviewIsDragStartProvider)
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
        logger.d("dt: TopLeft: $data");
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
        logger.d("dt: TopRight: $data");
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
        logger.d("dt: BottomLeft: $data");
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
        logger.d("dt: BottomRight: $data");
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
