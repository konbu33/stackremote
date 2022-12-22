import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../channel/channel.dart';

class RtcVideoRemotePreviewWidget extends HookConsumerWidget {
  const RtcVideoRemotePreviewWidget({
    super.key,
    required this.remoteUid,
  });

  final int remoteUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelName = ref.watch(channelNameProvider);

    const notExistRemoteUserWidget = Text(
      'Please wait remote user join',
      textAlign: TextAlign.center,
    );

    if (remoteUid == 0) return notExistRemoteUserWidget;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return SurfaceView(uid: remoteUid, channelId: channelName);

      case TargetPlatform.iOS:
        return SurfaceView(uid: remoteUid, channelId: channelName);

      case TargetPlatform.windows:
        return TextureView(uid: remoteUid, channelId: channelName);

      case TargetPlatform.macOS:
        return TextureView(uid: remoteUid, channelId: channelName);

      default:
        return notExistRemoteUserWidget;
    }
  }
}
