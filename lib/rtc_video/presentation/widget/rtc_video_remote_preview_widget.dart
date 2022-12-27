import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../channel/channel.dart';
import '../../../common/common.dart';
import '../../infrastructure/rtc_video_engine_agora.dart';
import 'rtc_video_local_preview_widget.dart';

class RtcVideoRemotePreviewWidget extends HookConsumerWidget {
  const RtcVideoRemotePreviewWidget({
    super.key,
    required this.remoteUid,
  });

  final int remoteUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, child) {
      //

      final rtcVideoEngineAgora =
          ref.watch(rtcVideoEngineAgoraNotifierProvider);

      final channelName = ref.watch(channelNameProvider);

      final videoViewControllerRemote = VideoViewController.remote(
        rtcEngine: rtcVideoEngineAgora!,
        canvas: VideoCanvas(uid: remoteUid),
        connection: RtcConnection(channelId: channelName),
        useFlutterTexture: ref.watch(isUseFlutterTextureProvider),
        useAndroidSurfaceView: ref.watch(isUseAndroidSurfaceViewProvider),
      );

      logger
          .d("preview remote : data rtcVideoEngineAgora: $rtcVideoEngineAgora");

      logger.d(
          "preview remote : data useFlutterTexture: ${videoViewControllerRemote.useFlutterTexture}");
      logger.d(
          "preview remote : data useAndroidSurfaceView: ${videoViewControllerRemote.useAndroidSurfaceView}");
      logger.d(
          "preview remote : data channelId: ${videoViewControllerRemote.connection.channelId}");
      logger.d(
          "preview remote : data localUid: ${videoViewControllerRemote.connection.localUid}");

      return AgoraVideoView(controller: videoViewControllerRemote);

      // return rtcVideoEngineAgora.when(data: (rtcEngine) {
      //   //
      //   final videoViewControllerRemote = VideoViewController.remote(
      //     rtcEngine: rtcEngine,
      //     canvas: VideoCanvas(uid: remoteUid),
      //     connection: RtcConnection(channelId: channelName),
      //     useFlutterTexture: ref.watch(isUseFlutterTextureProvider),
      //     useAndroidSurfaceView: ref.watch(isUseAndroidSurfaceViewProvider),
      //   );

      //   logger.d(
      //       "preview remote : data useFlutterTexture: ${videoViewControllerRemote.useFlutterTexture}");
      //   logger.d(
      //       "preview remote : data useAndroidSurfaceView: ${videoViewControllerRemote.useAndroidSurfaceView}");
      //   logger.d(
      //       "preview remote : data channelId: ${videoViewControllerRemote.connection.channelId}");
      //   logger.d(
      //       "preview remote : data localUid: ${videoViewControllerRemote.connection.localUid}");

      //   logger.d(
      //       "preview remote : data rtcEngine: ${videoViewControllerRemote.rtcEngine}");

      //   return AgoraVideoView(controller: videoViewControllerRemote);
      // }, error: (error, stackTrace) {
      //   logger.d("preview remote : error ");

      //   return Text("error: $error, stackTrace: $stackTrace");
      // }, loading: () {
      //   logger.d("preview remote : loading");

      //   return const CircularProgressIndicator();
      // });
    });
  }
}
