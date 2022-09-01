import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import '../page/agora_video_page_state.dart';

class AgoraVideoLeaveChannelWidget extends StatelessWidget {
  const AgoraVideoLeaveChannelWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  final AgoraVideoPageState state;

// --------------------------------------------------
//
//
// Init the app
//
//
// --------------------------------------------------
  Future<void> leaveChannel(AgoraVideoPageState state) async {
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
        print("on leave channel ---------- : stats : ${rtcStats.toString()}");
      }),
    );

    // イベントハンドラ指定
    engine.setEventHandler(handler);

    // チャンネル離脱
    try {
      await engine.leaveChannel();
    } catch (e) {
      print("${e.toString()}");
    }
  }

// --------------------------------------------------
//
//
// build
//
//
// --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await leaveChannel(state);
        },
        child: const Text("leave channel"));
  }
}
