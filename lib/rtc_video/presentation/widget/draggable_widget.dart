import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:stackremote/rtc_video/presentation/page/rtc_video_page_state.dart';

import '../../../common/common.dart';
import 'clipped_video.dart';

final remotePreviewIsDragStartProvider = StateProvider((ref) => false);

final remotePreviewPositionProvider =
    StateProvider((ref) => const Offset(0, 0));

final remotePreviewSizeProvider = StateProvider((ref) => const Size(100, 100));

class DraggableWidget extends HookConsumerWidget {
  const DraggableWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget clippedChild = ClippedVideo(
      height: ref.watch(remotePreviewSizeProvider).height,
      width: ref.watch(remotePreviewSizeProvider).width,
      child: child,
    );

    return Positioned(
      top: ref.watch(remotePreviewPositionProvider).dy,
      left: ref.watch(remotePreviewPositionProvider).dx,
      // top: 100,
      // left: 200,
      child: Draggable(
        onDragStarted: () {
          ref
              .read(remotePreviewIsDragStartProvider.notifier)
              .update((state) => true);
        },
        onDragUpdate: (draggableDetails) {
          logger.d("draggableDetails : ${draggableDetails.localPosition}");

          // ref
          //     .read(remotePreviewPositionProvider.notifier)
          //     .update((state) => draggableDetails.offset);

          ref
              .read(remotePreviewPositionProvider.notifier)
              .update((state) => state + draggableDetails.delta);

          // ref
          //     .read(remotePreviewIsDragStartProvider.notifier)
          //     .update((state) => false);
        },
        onDragEnd: (draggableDetails) {
          // logger.d("draggableDetails : ${draggableDetails.offset}");

          // ref
          //     .read(remotePreviewPositionProvider.notifier)
          //     .update((state) => draggableDetails.offset);

          // ref
          //     .read(remotePreviewPositionProvider.notifier)
          //     .update((state) => const Offset(300, 300));

          ref
              .read(remotePreviewIsDragStartProvider.notifier)
              .update((state) => false);
        },
        feedback: clippedChild,
        //   Container(
        // color: Colors.red,
        // height: 100,
        // width: 100,
        // child: child,
        // ),
        child:
            // Container(
            //   color: Colors.red,
            //   height: 100,
            //   width: 100,
            //   child: child,
            // ),

            ref.watch(remotePreviewIsDragStartProvider)
                ? const SizedBox(
                    height: 100,
                    width: 100,
                  )
                : clippedChild,
      ),
    );
  }
}

// class PositionedWidget extends HookConsumerWidget {
//   const PositionedWidget({super.key, required this.child});

//   final Widget child;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return     );
//   }
// }

// --------------------------------------------------
//
// Transform.translateとonPanUpdateを利用したD&D
//
// --------------------------------------------------
// Transform.translate(
//           offset: ref.watch(remotePreviewPositionProvider),
//           child: GestureDetector(
//             onTap: () {
//               ref
//                   .read(RtcVideoPageState.viewSwitchProvider.notifier)
//                   .update((state) => !state);
//             },
//             onPanUpdate: (details) {
//               logger.d("onPanUpdate: ${details.localPosition}");
//               ref
//                   .read(remotePreviewPositionProvider.notifier)
//                   .update((state) => state + details.delta);
//             },
//             child: ClippedVideo(
//               height: 100,
//               width: 100,
//               // alignment: Alignment.center,
//               child: ref.watch(RtcVideoPageState.viewSwitchProvider)
//                   ? RtcVideoPageWidgets.localPreviewWidget()
//                   : RtcVideoPageWidgets.remotePreviewWidget(),
//             ),
//           ));
