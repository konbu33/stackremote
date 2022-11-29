// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;

class AgoraVideoLocalPreviewWidget extends StatelessWidget {
  const AgoraVideoLocalPreviewWidget({
    Key? key,
    required this.isJoinedChannel,
  }) : super(key: key);

  final bool isJoinedChannel;

  // @override
  // Widget build(BuildContext context) {
  //   return AgoraVideoView(
  //     controller: VideoViewController(
  //       rtcEngine: createAgoraRtcEngine(),
  //       canvas: VideoCanvas(uid: state.localUid),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (isJoinedChannel && defaultTargetPlatform == TargetPlatform.android ||
        isJoinedChannel && defaultTargetPlatform == TargetPlatform.iOS) {
      return const rtc_local_view.SurfaceView();
    }

    if (isJoinedChannel && defaultTargetPlatform == TargetPlatform.windows ||
        isJoinedChannel && defaultTargetPlatform == TargetPlatform.macOS) {
      return const rtc_local_view.TextureView();
    } else {
      return const Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }
}
