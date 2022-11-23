import 'dart:io';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ulid/ulid.dart';

part 'rtc_channel_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class RtcChannelState with _$RtcChannelState {
  const factory RtcChannelState._({
    //
    required String appId,
    // ignore: unused_element
    @Default("") String rtcIdToken,
    // ignore: unused_element
    @Default("") String channelName,
    @Default(0) int localUid,
    required String account,
    required String rtcIdTokenType,
    required String role,
    required int privilegeExpireTime,
    //
    // ignore: unused_element
    @Default(false) bool joined,
    // ignore: unused_element
    @Default(1) int remoteUid,
    //
    required LogConfig tempLogConfig,
  }) = _RtcChannelState;

  factory RtcChannelState.create() => RtcChannelState._(
        appId: dotenv.get("APP_ID"),
        rtcIdTokenType: "uid",
        role: "publisher",
        account: Ulid().toString(),
        privilegeExpireTime: 4000,
        // localUid: DateTime.now().millisecondsSinceEpoch,
        localUid: 1,
        tempLogConfig: LogConfig(),
      );
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class RtcChannelStateNotifier extends StateNotifier<RtcChannelState> {
  RtcChannelStateNotifier() : super(RtcChannelState.create()) {
    initial();
    setTempLogConfig();
  }

  // initial
  void initial() {
    state = RtcChannelState.create();
  }

  void updateToken(String newToken) {
    state = state.copyWith(rtcIdToken: newToken);
  }

  void updateChannelName(String newChannelName) {
    state = state.copyWith(channelName: newChannelName);
  }

  void changeJoined(bool joined) {
    state = state.copyWith(joined: joined);
  }

  void setRemoteUid(int remoteUid) {
    state = state.copyWith(remoteUid: remoteUid);
  }

  void setTempLogConfig() async {
    // ログ出力
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

    state = state.copyWith(tempLogConfig: tempLogConfig);
  }
}

// --------------------------------------------------
//
//  typedef Provider
//
// --------------------------------------------------
typedef RtcChannelStateNotifierProvider
    = StateNotifierProvider<RtcChannelStateNotifier, RtcChannelState>;

// --------------------------------------------------
//
//  StateNotifierProviderCreator
//
// --------------------------------------------------
RtcChannelStateNotifierProvider rtcChannelStateNotifierProviderCreator() {
  return StateNotifierProvider<RtcChannelStateNotifier, RtcChannelState>((ref) {
    return RtcChannelStateNotifier();
  });
}

// --------------------------------------------------
//
//  rtcChannelStateNotifierProvider
//
// --------------------------------------------------
final rtcChannelStateNotifierProvider =
    rtcChannelStateNotifierProviderCreator();
