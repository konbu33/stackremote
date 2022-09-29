import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;

import '../../usecase/rtc_channel_state.dart';

class AgoraVideoLocalPreviewWidget extends StatelessWidget {
  const AgoraVideoLocalPreviewWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  final RtcChannelState state;

  @override
  Widget build(BuildContext context) {
    if (state.joined && defaultTargetPlatform == TargetPlatform.android ||
        state.joined && defaultTargetPlatform == TargetPlatform.iOS) {
      return const rtc_local_view.SurfaceView();
    }

    if (state.joined && defaultTargetPlatform == TargetPlatform.windows ||
        state.joined && defaultTargetPlatform == TargetPlatform.macOS) {
      return const rtc_local_view.TextureView();
    } else {
      return const Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }
}