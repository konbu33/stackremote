import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../common/common.dart';

import '../domain/rtc_video_state.dart';
import '../presentation/widget/video_main_state.dart';

String appIdCreator() {
  return dotenv.get("APP_ID");
}

Future<LogConfig?> tempLogConfigCreator() async {
  // ログ出力
  try {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    // print("tempPath : ${tempPath}");

    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String appDocPath = appDocDir.path;
    // print("appDocPath : ${appDocPath}");

    final LogConfig tempLogConfig =
        LogConfig(filePath: "$tempPath/rtc_video_engine_agora.temp.log");
    // final LogConfig logConfig = LogConfig();
    // LogConfig(filePath: "${tempPath}/rtc_video_engine_agora.custom.log");

    return tempLogConfig;
  } catch (e, s) {
    logger.d("$e, $s");
    return null;
  }
}

Future<RtcEngine> createRtcVideoEngineAgoraInstance() async {
  final appId = appIdCreator();

  // log設定
  final tempLogConfig = await tempLogConfigCreator();

  // 接続先のAgoraのプロジェクトをAppIdで指定
  // ログ出力先も指定
  final engine = createAgoraRtcEngine();

  final context = RtcEngineContext(
    appId: appId,
    logConfig: tempLogConfig,
  );

  // RTC client instance作成
  await engine.initialize(context);

  // ビデオ有効化
  // チャンネルに参加する前にこのメソッドを呼び出した場合、ビデオモードで通話が開始されます。
  await engine.enableVideo();

  // 初期状態で、ビデオは有効化しているが、まだ自分のカメラでビデオ映像の配信はしない(ミュートした状態)
  await engine.muteLocalVideoStream(true);

  // ビデオのエンコーディング設定
  const videoEncoderConfiguration = VideoEncoderConfiguration(
    // dimensions: VideoDimensions(width: 640, height: 360), // 16 : 9
    // dimensions: VideoDimensions(width: 720, height: 1280), // 9 : 16
    dimensions: VideoDimensions(width: 360, height: 640), // 9 : 16
    frameRate: 15,
    bitrate: 0,
  );

  await engine.setVideoEncoderConfiguration(videoEncoderConfiguration);

  return engine;
}

final rtcVideoEngineAgoraHandlerProvider = Provider((ref) {
  // イベントハンドラ定義
  final handler = RtcEngineEventHandler(
    // チャンネル参加が成功した場合
    onJoinChannelSuccess: ((connection, elapsed) {
      logger.d(
          "agora onJoinChannelSuccess: channelId: ${connection.channelId}, localUid: ${connection.localUid}, elapsed: $elapsed");

      ref
          .watch(RtcVideoState.isJoinedChannelProvider.notifier)
          .update((state) => true);
    }),

    // 他ユーザがチャンネル参加してきた場合
    onUserJoined: ((connection, remoteUid, elapsed) {
      logger.d(
          "agora onUserJoined: connection: ${connection.toString()}, remoteUid: $remoteUid, elapsed: $elapsed");

      ref
          .watch(RtcVideoState.remoteUidProvider.notifier)
          .update((state) => remoteUid);
    }),

    // チャンネル参加がオフラインになった場合
    onUserOffline: (connection, remoteUid, reason) {
      logger.d(
          "agora onUserOffline: connection: ${connection.toString()}, remoteUid: $remoteUid, reason: $reason");

      ref.watch(RtcVideoState.remoteUidProvider.notifier).update((state) => 0);
    },

    // チャンネル離脱した場合
    onLeaveChannel: ((connection, rtcStats) {
      logger.d(
          "agora onLeaveChannel: connection: ${connection.toString()}, rtcStats: $rtcStats");

      ref
          .watch(RtcVideoState.isJoinedChannelProvider.notifier)
          .update((state) => false);
    }),

    onUserEnableVideo: (connection, remoteUid, enabled) async {
      logger.d(
          "agora onUserEnableVideo: connection: ${connection.toString()}, remoteUid: $remoteUid, enabled: $enabled");

      //
    },

    onUserMuteVideo: (connection, remoteUid, muted) async {
      logger.d(
          "agora onUserMuteVideo: connection: ${connection.toString()}, remoteUid: $remoteUid, muted: $muted");

      final currentUid = ref.read(
          videoMainStateNotifierProvider.select((value) => value.currentUid));

      if (currentUid == remoteUid) {
        ref
            .read(videoMainStateNotifierProvider.notifier)
            .updateIsMuteVideo(muted);
      }
      //
    },

    onUserMuteAudio: (connection, remoteUid, muted) {
      logger.d(
          "agora onUserMuteAudio: connection: ${connection.toString()}, remoteUid: $remoteUid, muted: $muted");

      //
    },

    onRejoinChannelSuccess: (connection, elapsed) {
      logger.d(
          "agora onRejoinChannelSuccess:  connection: ${connection.toString()}, elapsed: $elapsed");
    },

    onConnectionLost: ((connection) {
      logger.d("agora onConnectionLost: ");
    }),

    onError: ((err, msg) {
      logger
          .d("agora onError: index: ${err.index}, name: ${err.name},err: $err");
    }),
  );

  return handler;
});

final rtcVideoEngineAgoraInstanceProvider = Provider<RtcEngine>((ref) {
  throw UnimplementedError();

  // 下記の通り、ProviderScopeのoverridesで上書き設定するため、
  // 初期化時点では、UnimplementedErrorをthrowしておく。
  // ProviderScope(
  //   overrides: [
  //     // sharedPreferencesインスタンス生成
  //     sharedPreferencesInstanceProvider
  //         .overrideWithValue(await createSharedPreferencesInstance()),
  //     rtcVideoEngineAgoraInstanceProvider
  //         .overrideWithValue(await createRtcVideoEngineAgoraInstance()),
  //   ],
  //   child: const MyApp(),
  // ),
});

final rtcVideoEngineAgoraProvider = Provider<RtcEngine>((ref) {
  final rtcVideoEngineAgoraInstance =
      ref.watch(rtcVideoEngineAgoraInstanceProvider);

  final rtcVideoEngineAgoraHandler =
      ref.watch(rtcVideoEngineAgoraHandlerProvider);

  rtcVideoEngineAgoraInstance.registerEventHandler(rtcVideoEngineAgoraHandler);

  return rtcVideoEngineAgoraInstance;
});
