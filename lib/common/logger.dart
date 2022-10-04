import 'package:logger/logger.dart';

import 'common.dart';

// --------------------------------------------------
//
// ロギングのインスタンス生成し、保持
//
// --------------------------------------------------
Logger logger = Logger(
  level: null,
  printer: PrettyPrinter(
    printTime: true,
  ),
);

// --------------------------------------------------
//
// ログレベル設定
//
// --------------------------------------------------
void setLogLevel(ReleaseEnv releaseEnv) {
  switch (releaseEnv) {
    case ReleaseEnv.stg:
      logger = Logger(
        level: Level.info,
        printer: PrettyPrinter(
          printTime: true,
        ),
      );

      break;

    case ReleaseEnv.prd:
      logger = Logger(
        level: Level.warning,
        printer: PrettyPrinter(
          printTime: true,
        ),
      );

      break;

    default:
  }
}
