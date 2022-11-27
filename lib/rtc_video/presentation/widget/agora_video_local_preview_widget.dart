// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;

class AgoraVideoLocalPreviewWidget extends StatelessWidget {
  const AgoraVideoLocalPreviewWidget({
    Key? key,
    required this.isJoined,
  }) : super(key: key);

  final bool isJoined;

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
    if (isJoined && defaultTargetPlatform == TargetPlatform.android ||
        isJoined && defaultTargetPlatform == TargetPlatform.iOS) {
      return const rtc_local_view.SurfaceView();
    }

    if (isJoined && defaultTargetPlatform == TargetPlatform.windows ||
        isJoined && defaultTargetPlatform == TargetPlatform.macOS) {
      return const rtc_local_view.TextureView();
    } else {
      return const Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }
}
