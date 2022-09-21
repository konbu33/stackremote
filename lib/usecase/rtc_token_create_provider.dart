// onRequest
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/domain/user.dart';
import 'package:stackremote/usecase/rtc_channel_state.dart';

// onCall
import 'package:cloud_functions/cloud_functions.dart';

final rtcTokenCreateOnCallProvider = Provider((ref) {
  Future<String> rtcCreateToken() async {
    final state = ref.watch(
        RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

    final userState = ref.watch(userStateNotifierProvider);

    final notifier = ref.read(RtcChannelStateNotifierProviderList
        .rtcChannelStateNotifierProvider.notifier);

    final data = {
      "channelName": state.channelName,
      "localUid": state.localUid,
      "account": state.account,
      "rtcIdTokenType": state.rtcIdTokenType,
      "role": state.role,
      "privilegeExpireTime": state.privilegeExpireTime,
      "firebaseAuthIdToken": userState.firebaseAuthIdToken,
    };

    // Cloud Functionsのインスタンス生成
    FirebaseFunctions instance = FirebaseFunctions.instance;

    // Cloud Functinosの関数のホスト先が、ローカル環環のエミュレータの場合

    instance.useFunctionsEmulator(
      dotenv.get("FIREBASE_EMULATOR_IP"),
      int.parse(dotenv.get("FIREBASE_EMULATOR_PORT")),
    );

    // Cloud Functionsの関数呼び出し。dataを渡す。
    final HttpsCallableResult result =
        await instance.httpsCallable('createRtcIdToken').call(data);

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

    // rtcIdToken を状態として保持する
    // notifier.updateToken(rtcIdToken);

    return rtcIdToken;
  }

  return rtcCreateToken;
});

final rtcTokenCreateOnRequestProvider = Provider((ref) {
  Future<String> rtcCreateToken() async {
    final state = ref.watch(
        RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

    final userState = ref.watch(userStateNotifierProvider);

    final notifier = ref.read(RtcChannelStateNotifierProviderList
        .rtcChannelStateNotifierProvider.notifier);

    // rtcIdToken Create API Endpoint
    // final String baseUrl = state.rtcIdTokenApiUrl;
    final String baseUrl = state.rtcIdTokenApiUrl;
    const String onRequestFunctionName = "createRtcIdTokenOnRequest";
    const String queryString = "";
    final String url = baseUrl + onRequestFunctionName + queryString;

    // print("url : ------------------------------------------ ${url}");

    // data in request body
    final data = {
      // "uid": state.localUid,
      "channelName": state.channelName,
      "localUid": state.localUid,
      "account": state.account,
      "rtcIdTokenType": state.rtcIdTokenType,
      "role": state.role,
      "privilegeExpireTime": state.privilegeExpireTime,
      "firebaseAuthIdToken": userState.firebaseAuthIdToken,
    };

    // print("data : $data");
    // print("data json ------------------------------- : ${jsonEncode(data)}");

    final formData = FormData.fromMap(data);

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

      print("res : ------------------------------------------ ${res}");

      final resJson = jsonDecode(res.data["data"]);
      final String token = resJson["rtcIdToken"];
      print(
          "res rtcIdToken  -------------------------------------- : ${token}");

      // state = state.copyWith(token: token);
      notifier.updateToken(token);

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

  return rtcCreateToken;
});
