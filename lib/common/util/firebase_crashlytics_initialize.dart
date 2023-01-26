import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

Future<void> firebaseCrashlyticsInitialize() async {
  // FlutterError.onErrorをFirebaseCrashlytics.instance.recordFlutterFatalErrorでオーバーライドすることにより、Flutter フレームワーク内でスローされたすべてのエラーを自動的にキャッチできます。
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Flutter フレームワークで処理されない非同期エラーをキャッチするには、 PlatformDispatcher.instance.onErrorを使用します。
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
