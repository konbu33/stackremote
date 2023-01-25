import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'common/common.dart';

import 'onboarding_layer.dart';
import 'rtc_video/infrastructure/rtc_video_engine_agora.dart';

void main() async {
  // リリース環境設定
  setByReleaseEnv();

  // ロギング設定・ログレベル設定
  setLogLevel(releaseEnv);

  // Firebase初期化
  await firebaseInitialize();

  // flutter_dotenvで変数読み込み
  await loadDotEnv();

  // 画面の向きを縦に固定
  await setPreferredOrientationsPortraitUp();

  // riverpod範囲指定
  runApp(
    ProviderScope(
      overrides: [
        // sharedPreferencesインスタンス生成
        sharedPreferencesInstanceProvider
            .overrideWithValue(await createSharedPreferencesInstance()),
        rtcVideoEngineAgoraInstanceProvider
            .overrideWithValue(await createRtcVideoEngineAgoraInstance()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnBoardingLayer();
  }
}
