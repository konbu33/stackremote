import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../../pointer/pointer.dart';
import '../../../user/user.dart';

import '../../domain/display_size_video_state.dart';
import 'rtc_video_local_preview_widget.dart';
import 'rtc_video_remote_preview_widget.dart';
import 'video_main_state.dart';
import 'video_mute_widget.dart';

class VideoMainWidget extends StatelessWidget {
  const VideoMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return LayoutBuilder(builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth.floorToDouble(),
          constraints.maxHeight.floorToDouble(),
        );

        void setDisplaySizeVideoMain(Size? size) {
          if (size == null) return;

          ref
              .read(DisplaySizeVideoState.displaySizeVideoMainProvider.notifier)
              .update((state) => size);
        }

        final buildedCallback = ref.watch(buildedCallbackProvider);
        buildedCallback<Size>(callback: setDisplaySizeVideoMain, data: size);

        return VideoMainWidgetParts.videoMainWidget();
      });
    });
  }
}

class VideoMainWidgetParts {
  // videoMainWidget
  static videoMainWidget() {
    final widget = Consumer(builder: (context, ref, child) {
      final isMuteVideo = ref.watch(
          videoMainStateNotifierProvider.select((value) => value.isMuteVideo));

      final currentUid = ref.watch(
          videoMainStateNotifierProvider.select((value) => value.currentUid));

      final nickName = ref.watch(
          videoMainStateNotifierProvider.select((value) => value.nickName));

      final localUid = ref.watch(
          userStateNotifierProvider.select((value) => value.rtcVideoUid));

      final displaySizeVideoMainMin =
          ref.watch(DisplaySizeVideoState.displaySizeVideoMainMinProvider);

      return Container(
        height: displaySizeVideoMainMin.height,
        width: displaySizeVideoMainMin.width,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 3.0,
              color: ref.watch(videoMainStateNotifierProvider).userColor.color,
            ),
          ),
        ),
        child: PointerOverlayWidget(
          child: Builder(builder: (context) {
            //
            if (isMuteVideo) {
              return VideoMuteWidget(nickName: nickName);
            }

            return Column(
              children: [
                Expanded(
                  child: currentUid == localUid
                      ? const RtcVideoLocalPreviewWidget()
                      : RtcVideoRemotePreviewWidget(remoteUid: currentUid),
                ),
                SizedBox(
                  height: 30,
                  child: Text(
                      "displaySizeVideoMainMin: h: ${displaySizeVideoMainMin.height}, w: ${displaySizeVideoMainMin.width}"),
                ),
              ],
            );
          }),
        ),
      );
    });

    return widget;
  }
}
