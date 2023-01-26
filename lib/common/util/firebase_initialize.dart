import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';
import 'logger.dart';

// --------------------------------------------------
//
// Firebase初期化
//
// --------------------------------------------------
Future<FirebaseApp> firebaseInitialize() async {
  logger.d("start: Firebase Initialize");

  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  logger.d("end: Firebase Initialize");

  return app;
}
