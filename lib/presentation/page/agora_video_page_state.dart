// import 'dart:convert';
// import 'dart:io';

// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:path_provider/path_provider.dart';

part 'agora_video_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class AgoraVideoPageState with _$AgoraVideoPageState {
  const factory AgoraVideoPageState._({
    //
    // required String appId,
    // required String token,
    // required String createTokenUrl,
    //
    // @Default(false) bool joined,
    // @Default(0) int remoteUid,
    @Default(false) bool viewSwitch,

    //
    // required LogConfig tempLogConfig,
  }) = _AgoraVideoPageState;

  factory AgoraVideoPageState.create() => AgoraVideoPageState._(
      // appId: dotenv.get("APP_ID"),
      // token: dotenv.get("Token"),
      // createTokenUrl: dotenv.get("CreateTokenUrl"),
      // tempLogConfig: LogConfig(),
      );
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class AgoraVideoPageStateNotifier extends StateNotifier<AgoraVideoPageState> {
  AgoraVideoPageStateNotifier() : super(AgoraVideoPageState.create()) {
    initial();
    // setTempLogConfig();
  }

  // initial
  void initial() {
    state = AgoraVideoPageState.create();
  }

  // void updateToken(String newToken) {
  //   state = state.copyWith(token: newToken);
  // }

  // void changeJoined(bool joined) {
  //   state = state.copyWith(joined: joined);
  // }

  // void setRemoteUid(int remoteUid) {
  //   state = state.copyWith(remoteUid: remoteUid);
  // }

  void toggleViewSwitch() {
    state = state.copyWith(viewSwitch: !state.viewSwitch);
  }

  // void setTempLogConfig() async {
  //   // ログ出力
  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //   // print("tempPath : ${tempPath}");

  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   String appDocPath = appDocDir.path;
  //   // print("appDocPath : ${appDocPath}");

  //   final LogConfig tempLogConfig =
  //       LogConfig(filePath: "${tempPath}/agora.temp.log");
  //   // final LogConfig logConfig = LogConfig();
  //   // LogConfig(filePath: "${tempPath}/custom_agora.log");

  //   state = state.copyWith(tempLogConfig: tempLogConfig);
  // }

}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final agoraVideoPageStateNotifierProvider = StateNotifierProvider.autoDispose<
    AgoraVideoPageStateNotifier, AgoraVideoPageState>(
  (ref) => AgoraVideoPageStateNotifier(),
);
