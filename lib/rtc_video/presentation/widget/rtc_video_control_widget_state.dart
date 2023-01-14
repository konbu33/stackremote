import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/rtc_video_state.dart';
import 'control_icon_widget_state.dart';

class RtcVideoControlWidgetState {
  //
  static final muteLocalAudioIconWidgetStateProvider = Provider((ref) {
    return ControlIconWidgetState.create(
      isMute: ref.watch(RtcVideoState.isMuteAudioLocalProvider),
      enableIcon: Icons.mic_sharp,
      disableIcon: Icons.mic_off_sharp,
      disableColor: Colors.grey,
      onPressed: () {
        ref
            .read(RtcVideoState.isMuteAudioLocalProvider.notifier)
            .update((state) => !state);
      },
    );
  });

  static final muteLocalVideoIconWidgetStateProvider = Provider((ref) {
    return ControlIconWidgetState.create(
      isMute: ref.watch(RtcVideoState.isMuteVideoLocalProvider),
      enableIcon: Icons.videocam_sharp,
      disableIcon: Icons.videocam_off_sharp,
      disableColor: Colors.grey,
      onPressed: () {
        ref
            .read(RtcVideoState.isMuteVideoLocalProvider.notifier)
            .update((state) => !state);
      },
    );
  });
}
