import 'package:logger/logger.dart';

import 'release_env.dart';

// --------------------------------------------------
//
// ロギングのインスタンス生成し、保持
//
// --------------------------------------------------
// improve: グローバル変変になっている？
LogPrinter logPrinter = PrettyPrinter(
  printTime: true,
);

Logger logger = Logger(
  printer: logPrinter,
);

// --------------------------------------------------
//
// ログレベル設定
//
// --------------------------------------------------
void setLogLevel(ReleaseEnv releaseEnv) {
  Level level = Level.debug;

  switch (releaseEnv) {
    case ReleaseEnv.stg:
      level = Level.info;

      break;

    case ReleaseEnv.prd:
      level = Level.warning;

      break;

    default:
  }

  logger = Logger(
    level: level,
    printer: logPrinter,
  );
}
