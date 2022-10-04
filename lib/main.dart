import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'authentication_layer.dart';
import 'firebase_options.dart';

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

  log();
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

// --------------------------------------------------
//
// .env読み込み
//
// --------------------------------------------------
Future<void> loadDotEnv() async {
  final logger = Logger(printer: PrettyPrinter());
  logger.d("start: load .env");
  await dotenv.load(fileName: ".env");
  logger.d("end: load .env");
}


var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    printTime: true,
  ),
);

void log() {
  Logger.level = Level.warning;
  logger.d("Log message with 2 methods");

  loggerNoStack.i("Info message");

  loggerNoStack.w("Just a warning!");

  logger.e("Error! Something bad happened", "Test Error");
  loggerNoStack.e("Error! Something bad happened", "Test Error");

  loggerNoStack.v({"key": 5, "value": "something"});

  firebaseAnalytics.logSelectContent(
      contentType: "image", itemId: "20221003-1025");

  Future.delayed(Duration(seconds: 5), log);
}
