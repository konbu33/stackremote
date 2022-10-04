import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'common.dart';

// --------------------------------------------------
//
// .env読み込み
//
// --------------------------------------------------
Future<void> loadDotEnv() async {
  logger.d("start: load .env");
  await dotenv.load(fileName: ".env");
  logger.d("end: load .env");
}
