import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/rtc_video_state.dart';
import 'control_icon_widget_state.dart';

class RtcVideoControlWidgetState {
  //
  static final muteLocalAudioIconWidgetStateProvider = Provider((ref) {
    return ControlIconWidgetState.create(
      isX: ref.watch(RtcVideoState.isMuteAudioLocalProvider),
      enableIcon: Icons.mic_sharp,
      disableIcon: Icons.mic_off_sharp,
      disableColor: Colors.grey,
      tooltip: "音声ミュート",
      onPressed: () {
        ref
            .read(RtcVideoState.isMuteAudioLocalProvider.notifier)
            .update((state) => !state);
      },
    );
  });

  static final muteLocalVideoIconWidgetStateProvider = Provider((ref) {
    return ControlIconWidgetState.create(
      isX: ref.watch(RtcVideoState.isMuteVideoLocalProvider),
      enableIcon: Icons.videocam_sharp,
      disableIcon: Icons.videocam_off_sharp,
      disableColor: Colors.grey,
      tooltip: "ビデオミュート",
      onPressed: () {
        ref
            .read(RtcVideoState.isMuteVideoLocalProvider.notifier)
            .update((state) => !state);
      },
    );
  });

  static final useOutSideCameraIconWidgetStateProvider = Provider((ref) {
    return ControlIconWidgetState.create(
      isX: ref.watch(RtcVideoState.isUseOutSideCameraProvider),
      enableIcon: Icons.cameraswitch_outlined,
      disableIcon: Icons.cameraswitch_outlined,
      disableColor: Colors.grey,
      tooltip: "カメラ切替",
      onPressed: () {
        ref
            .read(RtcVideoState.isUseOutSideCameraProvider.notifier)
            .update((state) => !state);
      },
    );
  });
}
