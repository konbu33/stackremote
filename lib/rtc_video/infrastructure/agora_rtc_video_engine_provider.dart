import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../common/common.dart';
import '../domain/rtc_channel_state.dart';

final appIdProvider = Provider((ref) => dotenv.get("APP_ID"));

final tempLogConfigProvider = Provider((ref) {
  //

  Future<LogConfig?> setTempLogConfig() async {
    // ログ出力
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      // print("tempPath : ${tempPath}");

      // Directory appDocDir = await getApplicationDocumentsDirectory();
      // String appDocPath = appDocDir.path;
      // print("appDocPath : ${appDocPath}");

      final LogConfig tempLogConfig =
          LogConfig(filePath: "$tempPath/agora.temp.log");
      // final LogConfig logConfig = LogConfig();
      // LogConfig(filePath: "${tempPath}/custom_agora.log");

      return tempLogConfig;
    } catch (e, s) {
      logger.d("$e, $s");
      return null;
    }
  }

  return setTempLogConfig();
});

final agoraRtcEngineCreatorProvider = Provider((ref) {
  // final notifier = ref.read(rtcChannelStateNotifierProvider.notifier);

  final appId = ref.watch(appIdProvider);

  Future<RtcEngine> agoraRtcEngineCreator() async {
    // log設定
    final tempLogConfig = await ref.watch(tempLogConfigProvider);

    // 接続先のAgoraのプロジェクトをAppIdで指定
    // ログ出力先も指定
    final RtcEngineContext context = RtcEngineContext(
      appId,
      logConfig: tempLogConfig,
      // logConfig: null,
    );

    // RTC client instance作成
    final engine = await RtcEngine.createWithContext(context);

    // イベントハンドラ定義
    final handler = RtcEngineEventHandler(
      // チャンネル参加が成功した場合
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        // print('joinChannelSuccess ${channel} ${uid}');
        // notifier.changeJoined(true);

        // --------------------------------------------------
        //
        // チャンネル参加済みであることをアプリ内で状態として保持する
        //
        // --------------------------------------------------
        ref
            .watch(RtcChannelState.isJoinedChannelProvider.notifier)
            .update((state) => true);

        //
      },

      // 他ユーザがチャンネル参加してきた場合
      userJoined: (int uid, int elapsed) {
        // print('userJoined ${uid}');
        // notifier.setRemoteUid(uid);
        ref
            .watch(RtcChannelState.remoteUidProvider.notifier)
            .update((state) => uid);
      },

      // チャンネル参加がオフラインになった場合
      userOffline: (int uid, UserOfflineReason reason) {
        // print('userOffline ${uid}');
        // notifier.setRemoteUid(0);
        ref
            .watch(RtcChannelState.remoteUidProvider.notifier)
            .update((state) => 0);
      },
      // チャンネル離脱した場合
      leaveChannel: (RtcStats rtcStats) {
        // --------------------------------------------------
        //
        // チャンネル離脱済みであることをアプリ内で状態として保持する
        //
        // --------------------------------------------------
        ref
            .watch(RtcChannelState.isJoinedChannelProvider.notifier)
            .update((state) => false);

        //
      },
    );

    // イベントハンドラ指定
    engine.setEventHandler(handler);

    // ビデオ有効化
    // チャンネルに参加する前にこのメソッドを呼び出した場合、ビデオモードで通話が開始されます。
    await engine.enableVideo();

    return engine;
  }

  return agoraRtcEngineCreator;
});
