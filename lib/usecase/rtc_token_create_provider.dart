import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/usecase/rtc_channel_state.dart';

final rtcTokenCreateProvider = Provider((ref) {
  Future<String> rtcCreateToken() async {
    final state = ref.watch(
        RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

    final notifier = ref.read(RtcChannelStateNotifierProviderList
        .rtcChannelStateNotifierProvider.notifier);

    print("create token");
    // final url = 'http://10.138.100.171:8082/fetch_rtc_token';
    final url = state.createTokenUrl;

    final data = {
      "uid": state.localUid,
      "channelName": state.channelName,
      "role": 1
    };
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
