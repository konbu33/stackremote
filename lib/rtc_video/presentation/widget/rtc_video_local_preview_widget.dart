import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../infrastructure/rtc_video_engine_agora.dart';

class RtcVideoLocalPreviewWidget extends StatelessWidget {
  const RtcVideoLocalPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      //

      final rtcVideoEngineAgora =
          ref.watch(rtcVideoEngineAgoraNotifierProvider);

      logger
          .d("preview local : data rtcVideoEngineAgora: $rtcVideoEngineAgora");

      final videoViewControllerLocal = VideoViewController(
        rtcEngine: rtcVideoEngineAgora!,
        canvas: const VideoCanvas(uid: 0),
        useFlutterTexture: ref.watch(isUseFlutterTextureProvider),
        useAndroidSurfaceView: ref.watch(isUseAndroidSurfaceViewProvider),
      );

      logger.d(
          "preview local : data useFlutterTexture: ${videoViewControllerLocal.useFlutterTexture}");
      logger.d(
          "preview local : data useAndroidSurfaceView: ${videoViewControllerLocal.useAndroidSurfaceView}");
      logger.d(
          "preview local : data channelId: ${videoViewControllerLocal.connection.channelId}");
      logger.d(
          "preview local : data localUid: ${videoViewControllerLocal.connection.localUid}");

      return AgoraVideoView(controller: videoViewControllerLocal);
    });
  }
}

final isUseFlutterTextureProvider = Provider((ref) {
  //
  bool isUseFlutterTexture = false;

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      isUseFlutterTexture = false;
      break;

    case TargetPlatform.iOS:
      isUseFlutterTexture = true;
      break;

    case TargetPlatform.windows:
      isUseFlutterTexture = true;
      break;

    case TargetPlatform.macOS:
      isUseFlutterTexture = true;
      break;

    default:
      isUseFlutterTexture = false;
      break;
  }
  return isUseFlutterTexture;
});

final isUseAndroidSurfaceViewProvider = Provider((ref) {
  bool isUseAndroidSurfaceView = false;

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      isUseAndroidSurfaceView = true;
      break;

    case TargetPlatform.iOS:
      isUseAndroidSurfaceView = false;
      break;

    case TargetPlatform.windows:
      isUseAndroidSurfaceView = false;
      break;

    case TargetPlatform.macOS:
      isUseAndroidSurfaceView = false;
      break;

    default:
      isUseAndroidSurfaceView = false;
      break;
  }

  return isUseAndroidSurfaceView;
});
