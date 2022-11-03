import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final createFirebaseExceptionMessageProvider = Provider((ref) {
  // improve: この関数は共通化した方が良さそう。
  String createErrorMessage(FirebaseException e) {
    switch (e.code) {
      case "requires-recent-login":
        // imporve: 下記のエラーが発生する懸念がある。深堀り必要そう。
        // Unhandled Exception: [firebase_auth/requires-recent-login] This operation is sensitive and requires recent authentication. Log in again before retrying this request.

        const String message = "前回のログインから一定時間が経過しているため、再ログインした後、改めて操作を行って下さい。";
        return message;
      default:
        return "想定外のエラーが発生しました。再ログインし直して下さい。";
    }
  }

  return createErrorMessage;
});
