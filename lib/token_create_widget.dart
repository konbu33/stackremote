import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers.dart';

class TokenCreateWidget extends HookConsumerWidget {
  const TokenCreateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> createToken() async {
      print("create token");
      final url = 'http://10.138.100.171:8082/fetch_rtc_token';

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
      }
    }
    //   } catch (e) {
    //     print("error : ${e.toString()}");
    //   }
    // }

    final state = ref.read(Providers.testProvider);
    return ElevatedButton(
      onPressed: () async {
        print("riverpod : ${state}");
        // await createToken();
      },
      child: const Text("Create Token"),
    );
  }
}
