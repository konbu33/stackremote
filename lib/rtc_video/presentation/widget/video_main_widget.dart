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
      final currentUid = ref.watch(VideoSubState.currentUidOfVideoMainProvider);

      final localUid = ref.watch(
          userStateNotifierProvider.select((value) => value.rtcVideoUid));

      return Column(
        children: [
          Expanded(
            child: currentUid == localUid
                ? const RtcVideoLocalPreviewWidget()
                : RtcVideoRemotePreviewWidget(remoteUid: currentUid),
          ),
          Text("currentUid : $currentUid"),
          Text(
              "Alignment: ${ref.watch(VideoSubState.videoSubLayerAlignmentProvider)}"),
        ],
      );
    });
  }
}
