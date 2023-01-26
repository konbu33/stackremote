import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> setPreferredOrientationsPortraitUp() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}
