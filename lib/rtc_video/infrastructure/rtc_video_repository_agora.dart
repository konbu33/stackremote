import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/common.dart';

import 'rtc_video_engine_agora.dart';
import 'rtc_video_repository.dart';

final rtcVideoRepositoryAgoraCreatorProvider = Provider((ref) {
  Future<RtcVideoRepositoryAgora> rtcVideoRepositoryAgoraCreator() async {
    final rtcVideoEngineAgora = ref.watch(rtcVideoEngineAgoraNotifierProvider);

    return RtcVideoRepositoryAgora(rtcEngine: rtcVideoEngineAgora!);
  }

  return rtcVideoRepositoryAgoraCreator;
});

class RtcVideoRepositoryAgora implements RtcVideoRepository {
  const RtcVideoRepositoryAgora({
    required this.rtcEngine,
  });

  @override
  final RtcEngine rtcEngine;

  // --------------------------------------------------
  //
  //  androidPermissionRequest
  //
  // --------------------------------------------------
  @override
  // Androidの場合、チャンネル参加前に、マイクとカメラの使用許可をリクエスト。明示的にリクエストする必要性は不明。
  Future<void> androidPermissionRequest() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
  }

  // --------------------------------------------------
  //
  //  channelJoin
  //
  // --------------------------------------------------
  @override
  Future<void> channelJoin({
    required String token,
    required String channelName,
    required int optionalUid,
  }) async {
    try {
      //
      await androidPermissionRequest();

      const channelMediaOptions = ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      );

      //
      await rtcEngine.joinChannel(
        token: token,
        channelId: channelName,
        uid: optionalUid,
        options: channelMediaOptions,
      );
    } on PlatformException catch (e) {
      //  PlatformException(-17, request to join channel is rejected, null, null)
      logger.d(
          "code: ${e.code}, message: ${e.message}, details: ${e.details}, stackTrace: ${e.stacktrace}");

      rethrow;

      //
    } on Exception catch (e) {
      logger.d("$e");
      rethrow;
    }
  }

  // --------------------------------------------------
  //
  //  channelLeave
  //
  // --------------------------------------------------

  @override
  Future<void> channelLeave() async {
    // チャンネル離脱
    try {
      await rtcEngine.leaveChannel();
    } on Exception catch (e) {
      logger.d("$e");
      rethrow;
    }
  }

  // --------------------------------------------------
  //
  //  switchCamera
  //
  // --------------------------------------------------

  @override
  Future<void> switchCamera() async {
    // チャンネル離脱
    try {
      await rtcEngine.switchCamera();
    } on Exception catch (e) {
      logger.d("$e");
      rethrow;
    }
  }

  // --------------------------------------------------
  //
  //  createRtcIdToken
  //  Firebase Functions OnCall用
  //
  // --------------------------------------------------
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

    try {
      final HttpsCallableResult result =
          await instance.httpsCallable(functionName).call(data);

      // improve: 下記エラー処理追加必要かもしれない。ネットワーク接続エラー？
      // PlatformException (PlatformException(firebase_functions, java.util.concurrent.ExecutionException: 1 out of 2 underlying tasks failed, {code: unknown, message: java.util.concurrent.ExecutionException: 1 out of 2 underlying tasks failed}, null))

      // 「Cloud Functions SDK のResult型のオブジェクト」から、
      // data属性(「Cloud Functionsに自分で定義した関数のResult型のオブジェクト」)をMap型で抽出する。
      final Map<String, dynamic> resultData =
          result.data as Map<String, dynamic>;

      // エラー処理 : コード:500の場合、Token生成に失敗とする。
      final int code = resultData["code"];
      if (code == 500) {
        throw FirebaseFunctionsException(
            message: "Tokenの生成に失敗しました。", code: code.toString());
      }

      // 抽出した「Cloud Functionsに自分で定義した関数のResult型のオブジェクト」から、data属性を抽出する。
      // data属性はString型なので、JsonDecodeを使用して、String型からMap型へ変換して抽出する。
      final Map<String, dynamic> rtcIdTokenData =
          jsonDecode(resultData["data"]);

      // 抽出したdata属性から、更にrtcIdTokenを抽出する。
      final rtcIdToken = rtcIdTokenData["rtcIdToken"];

      return rtcIdToken;
    } on FirebaseFunctionsException catch (error, stackTrace) {
      throw StackremoteException(
        plugin: error.plugin,
        message: error.message ?? "",
        code: error.code,
        stackTrace: stackTrace,
      );
    }
  }
}
