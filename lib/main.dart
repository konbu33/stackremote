import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication_layer.dart';
import 'firebase_options.dart';
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

// --------------------------------------------------
//
// Firebase初期化
//
// --------------------------------------------------
Future<void> firebaseInitialize() async {
  final logger = Logger();
  logger.d("start: Firebase Initialize");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.d("end: Firebase Initialize");
}


