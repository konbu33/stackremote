import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final createFirebaseAuthExceptionMessageProvider = Provider((ref) {
  //

  String createFirebaseAuthExceptionMessage(FirebaseAuthException e) {
    final String message;
    //

    switch (e.code) {
      case "user-not-found":
        message = "メールアドレス未登録です。";
        break;

      //  [firebase_auth/wrong-password] The password is invalid or the user does not have a password.
      case "wrong-password":
        message = "入力されたパスワードが誤っています。";
        break;

      case "too-many-requests":
        message = "認証回数が上限に達しました。";
        break;

      default:
        message = "想定外のエラーが発生しました。再ログインし直して下さい。";
        break;
    }

    return message;
  }

  return createFirebaseAuthExceptionMessage;
});
