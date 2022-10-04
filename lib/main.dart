import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'authentication_layer.dart';
import 'common/common.dart';

void main() async {
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AuthenticationLayer();
  }
}
