// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart';

class AgoraVideoRemotePreviewWidget extends StatelessWidget {
  const AgoraVideoRemotePreviewWidget({
    Key? key,
    required this.channelName,
    required this.remoteUid,
  }) : super(key: key);

  final String channelName;
  final int remoteUid;

  @override
  Widget build(BuildContext context) {
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
