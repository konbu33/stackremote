import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/agora_video.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stackremote/authentication/presentation/page/signin_page.dart';
import 'package:stackremote/authentication/presentation/widget/router_widget.dart';
import 'package:stackremote/custom_mouse_cursor/custom_mouse_cursor_overlay.dart';
import 'package:stackremote/home_page.dart';
import 'authentication/presentation/page/signup_page.dart';
import 'firebase_options.dart';

void main() async {
  // Firebase初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // flutter_dotenvで変数読み込み
  await dotenv.load(fileName: ".env");

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
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const HomePage(),
      // home: CustomMouseCursorOverlayer(child: AgoraVideoPage()),
      // home: CustomMouseCursorOverlayer(child: RouterWidget()),
      home: const RouterWidget(),
    );
  }
}
