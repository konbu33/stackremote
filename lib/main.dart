import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'common/common.dart';

import 'onboarding_layer.dart';

void main() async {
  // リリース環境設定
  setByReleaseEnv();

  // ロギング設定・ログレベル設定
  setLogLevel(releaseEnv);

  // Firebase初期化
  await firebaseInitialize();

  // flutter_dotenvで変数読み込み
  await loadDotEnv();

  // riverpod範囲指定
  runApp(
    const ProviderScope(
      child: MyApp(),
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
