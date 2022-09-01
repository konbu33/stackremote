import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

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
    required String appId,
    required String token,
    required String roomName,
    required String createTokenUrl,
    //
    @Default(false) bool joined,
    @Default(0) int remoteUid,
    @Default(false) bool viewSwitch,

    //
    required LogConfig tempLogConfig,
  }) = _AgoraVideoPageState;

  factory AgoraVideoPageState.create() => AgoraVideoPageState._(
        appId: dotenv.get("APP_ID"),
        token: dotenv.get("Token"),
        roomName: dotenv.get("RoomName"),
        createTokenUrl: dotenv.get("CreateTokenUrl"),
        tempLogConfig: LogConfig(),
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
    setTempLogConfig();
  }

  // initial
  void initial() {
    state = AgoraVideoPageState.create();
  }

  void updateToken(String newToken) {
    state = state.copyWith(token: newToken);
  }

  void changeJoined(bool joined) {
    state = state.copyWith(joined: joined);
  }

  void setRemoteUid(int remoteUid) {
    state = state.copyWith(remoteUid: remoteUid);
  }

  void toggleViewSwitch() {
    state = state.copyWith(viewSwitch: !state.viewSwitch);
  }

  void setTempLogConfig() async {
    // ログ出力
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    // print("tempPath : ${tempPath}");

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    // print("appDocPath : ${appDocPath}");

    final LogConfig tempLogConfig =
        LogConfig(filePath: "${tempPath}/agora.temp.log");
    // final LogConfig logConfig = LogConfig();
    // LogConfig(filePath: "${tempPath}/custom_agora.log");

    state = state.copyWith(tempLogConfig: tempLogConfig);
  }

  Future<String> createToken() async {
    print("create token");
    // final url = 'http://10.138.100.171:8082/fetch_rtc_token';
    final url = state.createTokenUrl;

    final data = {"uid": 123456, "channelName": "ChannelA", "role": 1};
    print("data : $data");
    print("data json: ${jsonEncode(data)}");

    final formData = FormData.fromMap(data);

    // axios.post('http://localhost:8082/fetch_rtc_token', {
    //     uid: uid,
    //     channelName: channelName,
    //     role: tokenRole
    // }, {
    //     headers: {
    //         'Content-Type': 'application/json; charset=UTF-8'
    //     }
    // }

    try {
      final res = await Dio().post(url,
          data: data,
          // data: jsonEncode(data),
          // data: formData,
          // queryParameters: data,
          // data: {"uid": 123456, "channelName": "ChannelA", "role": 1},
          options: Options(
            headers: {
              // "Content-Type": "application/json",
              // "Content-Type": 'application/json; charset=UTF-8',
              // Headers.contentTypeHeader: 'application/json; charset=UTF-8',
            },
          ));
      print("res : ${res}");

      final String token = res.data["token"];

      state = state.copyWith(token: token);

      return token;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print("1requestOptions : ${e.response!.requestOptions.data}");
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print("2requestOptions : ${e.requestOptions}");
        print(e.message);
      }
      return e.message;
    }
  }
  //   } catch (e) {
  //     print("error : ${e.toString()}");
  //   }
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
