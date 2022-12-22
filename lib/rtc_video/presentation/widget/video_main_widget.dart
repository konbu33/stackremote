import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../user/user.dart';

import 'rtc_video_local_preview_widget.dart';
import 'rtc_video_remote_preview_widget.dart';
import 'video_sub_state.dart';

class VideoMainWidget extends StatelessWidget {
  const VideoMainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final currentUidOfVideoMain = ref.watch(videoSubStateNotifierProvider
          .select((value) => value.currentUidOfVideoMain));

      final videoSubLayerAlignment = ref.watch(videoSubStateNotifierProvider
          .select((value) => value.videoSubLayerAlignment));

      final isOnTapIgnore = ref.watch(
          videoSubStateNotifierProvider.select((value) => value.isOnTapIgnore));

      final localUid = ref.watch(
          userStateNotifierProvider.select((value) => value.rtcVideoUid));

      return Column(
        children: [
          Expanded(
            child: currentUidOfVideoMain == localUid
                ? const RtcVideoLocalPreviewWidget()
                : RtcVideoRemotePreviewWidget(remoteUid: currentUidOfVideoMain),
          ),
          Text("currentUidOfVideoMain: $currentUidOfVideoMain"),
          Text("videoSubLayerAlignment: $videoSubLayerAlignment"),
          Text("isOnTapIgnore: $isOnTapIgnore"),
        ],
      );
    });
  }
}
