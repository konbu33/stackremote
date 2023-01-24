import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../../pointer/pointer.dart';
import '../../../user/user.dart';

import '../../domain/display_size_video_state.dart';
import '../../domain/rtc_video_state.dart';
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

        unawaited(Future(() {
          ref
              .read(DisplaySizeVideoState.displaySizeVideoMainProvider.notifier)
              .update((state) => size);
        }));

        return Column(children: [
          VideoMainWidgetParts.videoMainWidget(),
          VideoMainWidgetParts.updateVideoMainWidget(),
        ]);
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

      final continuousParticipationTimeRemaining =
          ref.watch(RtcVideoState.continuousParticipationTimeRemainingProvider);

      final displayTimeRemaining = continuousParticipationTimeRemaining
          .toString()
          .split('.')
          .first
          .padLeft(8, "0");

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
              return Column(
                children: [
                  Expanded(child: VideoMuteWidget(nickName: nickName)),
                  SizedBox(
                    height: 30,
                    child: Text("残り時間: $displayTimeRemaining"),
                  ),
                ],
              );
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
                  child: Text("残り時間: $displayTimeRemaining"),
                ),
                // SizedBox(
                //   height: 30,
                //   child: Text(
                //       "displaySizeVideoMainMin: h: ${displaySizeVideoMainMin.height}, w: ${displaySizeVideoMainMin.width}"),
                // ),
              ],
            );
          }),
        ),
      );
    });

    return widget;
  }

  // updateVideoMainWidget
  static updateVideoMainWidget() {
    final widget = Consumer(builder: (context, ref, child) {
      final userStateList =
          ref.watch(usersStateNotifierProvider.select((value) => value.users));

      if (userStateList.isEmpty) return const SizedBox();

      final currentUserOfVideoMainState = userStateList.where((user) {
        return user.rtcVideoUid ==
            ref.watch(videoMainStateNotifierProvider).currentUid;
      }).first;

      logger.d(
          "currentUserOfVideoMainState : ${currentUserOfVideoMainState.userColor}");

      if (currentUserOfVideoMainState.userColor !=
          ref.watch(videoMainStateNotifierProvider).userColor) {
        //
        unawaited(Future(() {
          ref
              .read(videoMainStateNotifierProvider.notifier)
              .updateUserColor(currentUserOfVideoMainState.userColor);
        }));
        //
      }

      return const SizedBox();
    });

    return widget;
  }
}
