// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class AgoraVideoRemotePreviewWidget extends StatelessWidget {
  const AgoraVideoRemotePreviewWidget({
    Key? key,
    required this.channelName,
    required this.remoteUid,
  }) : super(key: key);

  final String channelName;
  final int remoteUid;

  // @override
  // Widget build(BuildContext context) {
  //   // if (state.remoteUid != null) {
  //   return AgoraVideoView(
  //     controller: VideoViewController.remote(
  //       rtcEngine: createAgoraRtcEngine(),
  //       canvas: VideoCanvas(uid: state.remoteUid),
  //       connection: RtcConnection(
  //         channelId: state.channelName,
  //         localUid: state.localUid,
  //       ),
  //     ),
  //   );
  //   //   } else {
  //   //     return const Text(
  //   //       'Please wait for remote user to join',
  //   //       textAlign: TextAlign.center,
  //   //     );
  //   //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (remoteUid != 0 && defaultTargetPlatform == TargetPlatform.android ||
        remoteUid != 0 && defaultTargetPlatform == TargetPlatform.iOS) {
      return rtc_remote_view.SurfaceView(
        uid: remoteUid,
        channelId: channelName,
      );
    }

    if (remoteUid != 0 && defaultTargetPlatform == TargetPlatform.windows ||
        remoteUid != 0 && defaultTargetPlatform == TargetPlatform.macOS) {
      return rtc_remote_view.TextureView(
        uid: remoteUid,
        channelId: channelName,
      );
    } else {
      return const Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
  }
}
