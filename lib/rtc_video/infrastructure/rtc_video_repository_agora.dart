import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/common.dart';
import 'agora_rtc_video_engine_provider.dart';
import 'rtc_video_repository.dart';

final rtcVideoRepositoryAgoraProvider = Provider((ref) async {
  final agoraRtcEngineCreator = ref.watch(agoraRtcEngineCreatorProvider);
  final rtcEngine = await agoraRtcEngineCreator();

  // final agoraRtcEngineAsyncValue = ref.watch(agoraRtcEngineProvider);

  // final rtcEngine = agoraRtcEngineAsyncValue.when(data: (data) {
  //   return data;
  // }, error: (error, stackTrace) {
  //   logger.d("error: $error, stackTracke: $stackTrace");
  // }, loading: () {
  //   logger.d("loading...");
  // });

  return RtcVideoRepositoryAgora(rtcEngine: rtcEngine);
});

class RtcVideoRepositoryAgora implements RtcVideoRepository {
  const RtcVideoRepositoryAgora({
    required this.rtcEngine,
  });

  @override
  final RtcEngine rtcEngine;

  @override
  // Androidの場合、チャンネル参加前に、マイクとカメラの使用許可をリクエスト。明示的にリクエストする必要性は不明。
  Future<void> androidPermissionRequest() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
  }

  @override
  Future<void> channelJoin({
    required String token,
    required String channelName,
    required String? optionalInfo,
    required int optionalUid,
  }) async {
    try {
      //
      await androidPermissionRequest();

      //
      await rtcEngine.joinChannel(
        token,
        channelName,
        optionalInfo,
        optionalUid,
      );
    } on Exception catch (e) {
      logger.d("$e");
    }
  }

  @override
  Future<void> channelLeave() async {
    // チャンネル離脱
    try {
      await rtcEngine.leaveChannel();
    } on Exception catch (e) {
      logger.d("$e");
    }
  }

  // --------------------------------------------------
  //
  //  Firebase Functions OnCall用
  //
  // --------------------------------------------------
  // final state = ref.watch(rtcChannelStateNotifierProvider);
  // final notifier = ref.watch(rtcChannelStateNotifierProvider.notifier);

  @override
  Future<String> createRtcIdToken({
    required String channelName,
    required int localUid,
    required String account,
    required String rtcIdTokenType,
    required String role,
    required int privilegeExpireTime,
  }) async {
    final data = {
      "channelName": channelName,
      "localUid": localUid,
      "account": account,
      "rtcIdTokenType": rtcIdTokenType,
      "role": role,
      "privilegeExpireTime": privilegeExpireTime,
    };

    // Cloud Functionsのインスタンス生成
    FirebaseFunctions instance = FirebaseFunctions.instance;

    // Cloud Functinosの関数のホスト先が、ローカル環環のエミュレータの場合

    // instance.useFunctionsEmulator(
    //   dotenv.get("FIREBASE_EMULATOR_IP"),
    //   int.parse(dotenv.get("FIREBASE_EMULATOR_PORT")),
    // );

    // Cloud Functionsの関数呼び出し。dataを渡す。
    const functionName = 'createRtcIdToken';
    final HttpsCallableResult result =
        await instance.httpsCallable(functionName).call(data);

    // improve: 下記エラー処理追加必要かもしれない。ネットワーク接続エラー？
    // PlatformException (PlatformException(firebase_functions, java.util.concurrent.ExecutionException: 1 out of 2 underlying tasks failed, {code: unknown, message: java.util.concurrent.ExecutionException: 1 out of 2 underlying tasks failed}, null))

    // 「Cloud Functions SDK のResult型のオブジェクト」から、
    // data属性(「Cloud Functionsに自分で定義した関数のResult型のオブジェクト」)をMap型で抽出する。
    final Map<String, dynamic> resultData = result.data as Map<String, dynamic>;

    // エラー処理 : コード:500の場合、Token生成に失敗とする。
    final int code = resultData["code"];
    if (code == 500) {
      throw FirebaseFunctionsException(
          message: "Tokenの生成に失敗しました。", code: code.toString());
    }

    // 抽出した「Cloud Functionsに自分で定義した関数のResult型のオブジェクト」から、data属性を抽出する。
    // data属性はString型なので、JsonDecodeを使用して、String型からMap型へ変換して抽出する。
    final Map<String, dynamic> rtcIdTokenData = jsonDecode(resultData["data"]);

    // 抽出したdata属性から、更にrtcIdTokenを抽出する。
    final rtcIdToken = rtcIdTokenData["rtcIdToken"];

    // // rtcIdToken を状態として保持する
    // notifier.updateToken(rtcIdToken);

    return rtcIdToken;
  }
}
