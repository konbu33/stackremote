import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../common/common.dart';
import '../domain/rtc_video_state.dart';

final appIdCreatorProvider = Provider((ref) {
  String appIdCreator() {
    return dotenv.get("APP_ID");
  }

  return appIdCreator;
});

final tempLogConfigCreatorProvider = Provider((ref) {
  //

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

  return tempLogConfigCreator;
});

final rtcVideoEngineAgoraCreatorProvider = Provider((ref) {
  //

  Future<RtcEngine> rtcVideoEngineAgoraCreator() async {
    final appIdCreator = ref.watch(appIdCreatorProvider);
    final appId = appIdCreator();

    // log設定
    final tempLogConfigCreator = ref.watch(tempLogConfigCreatorProvider);
    final tempLogConfig = await tempLogConfigCreator();

    // 接続先のAgoraのプロジェクトをAppIdで指定
    // ログ出力先も指定
    final RtcEngineContext context = RtcEngineContext(
      appId,
      logConfig: tempLogConfig,
    );

    // RTC client instance作成
    final engine = await RtcEngine.createWithContext(context);

    // イベントハンドラ定義
    final handler = RtcEngineEventHandler(
      // チャンネル参加が成功した場合
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        logger.d(
            "agora joinChannelSuccess: channel: $channel, uid: $uid, elapsed: $elapsed");

        ref
            .watch(RtcVideoState.isJoinedChannelProvider.notifier)
            .update((state) => true);
      },

      // 他ユーザがチャンネル参加してきた場合
      userJoined: (int uid, int elapsed) {
        logger.d("agora userJoined: uid: $uid, elapsed: $elapsed");

        ref
            .watch(RtcVideoState.remoteUidProvider.notifier)
            .update((state) => uid);
      },

      // チャンネル参加がオフラインになった場合
      userOffline: (int uid, UserOfflineReason reason) {
        logger.d("agora userOffline: uid: $uid, reason: $reason");

        ref
            .watch(RtcVideoState.remoteUidProvider.notifier)
            .update((state) => 0);
      },

      // チャンネル離脱した場合
      leaveChannel: (RtcStats rtcStats) {
        logger.d("agora leaveChannel: rtcStats: $rtcStats");

        ref
            .watch(RtcVideoState.isJoinedChannelProvider.notifier)
            .update((state) => false);
      },

      rejoinChannelSuccess: (String channel, int uid, int elapsed) {
        logger.d(
            "agora rejoinChannelSuccess: channel: $channel, uid: $uid, elapsed: $elapsed");
      },

      connectionLost: () {
        logger.d("agora connectionLost: ");
      },

      error: (ErrorCode err) {
        logger
            .d("agora error: index: ${err.index}, name: ${err.name},err: $err");
      },
    );

    // イベントハンドラ指定
    engine.setEventHandler(handler);

    // ビデオ有効化
    // チャンネルに参加する前にこのメソッドを呼び出した場合、ビデオモードで通話が開始されます。
    await engine.enableVideo();

    return engine;
  }

  return rtcVideoEngineAgoraCreator;
});
