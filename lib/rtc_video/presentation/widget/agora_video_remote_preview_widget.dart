import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

import '../../domain/rtc_channel_state.dart';

class AgoraVideoRemotePreviewWidget extends StatelessWidget {
  const AgoraVideoRemotePreviewWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  final RtcChannelState state;

  @override
  Widget build(BuildContext context) {
    if (state.remoteUid != 0 &&
            defaultTargetPlatform == TargetPlatform.android ||
        state.remoteUid != 0 && defaultTargetPlatform == TargetPlatform.iOS) {
      return rtc_remote_view.SurfaceView(
        uid: state.remoteUid,
        channelId: state.channelName,
      );
    }

    if (state.remoteUid != 0 &&
            defaultTargetPlatform == TargetPlatform.windows ||
        state.remoteUid != 0 && defaultTargetPlatform == TargetPlatform.macOS) {
      return rtc_remote_view.TextureView(
        uid: state.remoteUid,
        channelId: state.channelName,
      );
    } else {
      return const Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
  }
}
