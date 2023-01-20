import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../channel/channel.dart';

import '../../infrastructure/rtc_video_engine_agora.dart';
import 'rtc_video_local_preview_widget.dart';

class RtcVideoRemotePreviewWidget extends StatelessWidget {
  const RtcVideoRemotePreviewWidget({
    super.key,
    required this.remoteUid,
  });

  final int remoteUid;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      //

      // final rtcVideoEngineAgora =
      //     ref.watch(rtcVideoEngineAgoraNotifierProvider);

      final rtcVideoEngineAgora = ref.watch(rtcVideoEngineAgoraProvider);

      final channelName = ref.watch(channelNameProvider);

      final videoViewControllerRemote = VideoViewController.remote(
        rtcEngine: rtcVideoEngineAgora,
        canvas: VideoCanvas(uid: remoteUid),
        connection: RtcConnection(channelId: channelName),
        useFlutterTexture: ref.watch(isUseFlutterTextureProvider),
        useAndroidSurfaceView: ref.watch(isUseAndroidSurfaceViewProvider),
      );

      return AgoraVideoView(controller: videoViewControllerRemote);
    });
  }
}
