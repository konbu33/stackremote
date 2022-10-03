import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/rtc_channel_state.dart';

final rtcLeaveChannelProvider = Provider((ref) {
  Future<void> rtcLeaveChannel() async {
    final state = ref.watch(
        RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

    // 接続先のAgoraのプロジェクトをAppIdで指定
    // ログ出力先も指定
    final RtcEngineContext context =
        RtcEngineContext(state.appId, logConfig: state.tempLogConfig);

    // RTC client instance作成
    final RtcEngine engine = await RtcEngine.createWithContext(context);

    // イベントハンドラ定義
    final RtcEngineEventHandler handler = RtcEngineEventHandler(
      // チャンネル離脱した場合
      leaveChannel: ((RtcStats rtcStats) {
        // print("on leave channel ---------- : stats : ${rtcStats.toString()}");
      }),
    );

    // イベントハンドラ指定
    engine.setEventHandler(handler);

    // チャンネル離脱
    try {
      await engine.leaveChannel();
    } catch (e) {
      // print("${e.toString()}");
    }
  }

  return rtcLeaveChannel;
});
