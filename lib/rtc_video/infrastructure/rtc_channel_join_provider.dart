// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../domain/rtc_channel_state.dart';

final rtcJoinChannelProvider = Provider((ref) {
  // Androidの場場、マイクとカメラの使用許可をリクエスト
  // 理由不明
  Future<void> androidPermissionRequest() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
  }

  // チャンネル参加
  Future<void> rtcJoinChannel() async {
    await androidPermissionRequest();

    final state = ref.watch(rtcChannelStateNotifierProvider);

    final notifier = ref.watch(rtcChannelStateNotifierProvider.notifier);

    // 接続先のAgoraのプロジェクトをAppIdで指定
    // ログ出力先も指定
    final RtcEngineContext context = RtcEngineContext(
      state.appId,
      logConfig: state.tempLogConfig,
    );

    // RTC client instance作成
    final RtcEngine engine = await RtcEngine.createWithContext(context);

    // イベントハンドラ定義
    final RtcEngineEventHandler handler = RtcEngineEventHandler(
      // チャンネル参加が成功した場合
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        // print('joinChannelSuccess ${channel} ${uid}');
        notifier.changeJoined(true);
      },

      // 他ユーザがチャンネル参加してきた場合
      userJoined: (int uid, int elapsed) {
        // print('userJoined ${uid}');
        notifier.setRemoteUid(uid);
      },

      // チャンネル参加がオフラインになった場合
      userOffline: (int uid, UserOfflineReason reason) {
        // print('userOffline ${uid}');
        notifier.setRemoteUid(0);
      },
    );

    // イベントハンドラ指定
    engine.setEventHandler(handler);

    // ビデオ有効化
    await engine.enableVideo();

    // チャンネル参加
    try {
      await engine.joinChannel(
        state.rtcIdToken,
        state.channelName,
        null,
        state.localUid,
      );
    } catch (e) {
      // print("${e.toString()}");
    }
  }

  return rtcJoinChannel;
});

// final rtcJoinChannelProvider = Provider((ref) {
//   // Androidの場場、マイクとカメラの使用許可をリクエスト
//   // 理由不明
//   Future<void> androidPermissionRequest() async {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       await [Permission.microphone, Permission.camera].request();
//     }
//   }

//   // チャンネル参加
//   Future<void> rtcJoinChannel() async {
//     await androidPermissionRequest();

//     final state = ref.watch(
//         RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

//     final notifier = ref.watch(RtcChannelStateNotifierProviderList
//         .rtcChannelStateNotifierProvider.notifier);

//     // 接続先のAgoraのプロジェクトをAppIdで指定
//     // ログ出力先も指定
//     final RtcEngineContext context = RtcEngineContext(
//       appId: state.appId,
//       logConfig: state.tempLogConfig,
//     );

//     // RTC client instance作成
//     // final RtcEngine engine = await RtcEngine.createWithContext(context);
//     final RtcEngine engine = createAgoraRtcEngine();
//     await engine.initialize(context);

//     // イベントハンドラ定義
//     final RtcEngineEventHandler handler = RtcEngineEventHandler(
//       // チャンネル参加が成功した場合
//       onJoinChannelSuccess: (
//         RtcConnection rtcConnection,
//         int uid,
//       ) {
//         // print('joinChannelSuccess ${channel} ${uid}');
//         notifier.changeJoined(true);
//       },

//       // 他ユーザがチャンネル参加してきた場合
//       onUserJoined: (
//         RtcConnection rtcConnection,
//         uid,
//         int elapsed,
//       ) {
//         // print('userJoined ${uid}');
//         notifier.setRemoteUid(uid);
//       },

//       // チャンネル参加がオフラインになった場合
//       onUserOffline: (
//         RtcConnection rtcConnection,
//         int uid,
//         UserOfflineReasonType reasonType,
//       ) {
//         // print('userOffline ${uid}');
//         notifier.setRemoteUid(0);
//       },
//     );

//     // イベントハンドラ指定
//     // engine.setEventHandler(handler);
//     engine.registerEventHandler(handler);

//     // ビデオ有効化
//     await engine.enableVideo();

//     // チャンネル参加
//     try {
//       await engine.joinChannel(
//         token: state.rtcIdToken,
//         channelId: state.channelName,
//         uid: state.localUid,
//         options: const ChannelMediaOptions(),
//       );
//     } catch (e) {
//       // print("${e.toString()}");
//     }
//   }

//   return rtcJoinChannel;
// });
