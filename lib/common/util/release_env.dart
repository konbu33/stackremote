import 'logger.dart';

// --------------------------------------------------
//
// リリース環境の分類
//
// --------------------------------------------------
enum ReleaseEnv {
  dev,
  stg,
  prd,
}

// --------------------------------------------------
//
// リリース環境の分類を状態として保持する
//
// --------------------------------------------------
ReleaseEnv releaseEnv = ReleaseEnv.dev;

// --------------------------------------------------
//
// リリース環境毎に設定分岐
//
// --------------------------------------------------
void setByReleaseEnv() {
  try {
    const flavor = String.fromEnvironment("FLAVOR");
    switch (flavor) {
      case "stg":
        releaseEnv = ReleaseEnv.stg;
        break;

      case "prd":
        releaseEnv = ReleaseEnv.prd;
        break;

      default:
    }
    logger.i(flavor);
  } catch (e) {
    logger.i(e);
  }
}
