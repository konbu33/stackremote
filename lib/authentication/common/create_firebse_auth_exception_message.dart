import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final createFirebaseAuthExceptionMessageProvider = Provider((ref) {
  //

  String createFirebaseAuthExceptionMessage(FirebaseAuthException e) {
    final String message;
    //

    switch (e.code) {
      // SignUp
      // [firebase_auth/email-already-in-use] The email address is already in use by another account.
      case "email-already-in-use":
        message = "メールアドレス登録済みです。";
        break;

      // SignIn
      // [firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.
      case "user-not-found":
        message = "メールアドレス未登録です。";
        break;

      //  [firebase_auth/wrong-password] The password is invalid or the user does not have a password.
      case "wrong-password":
        message = "入力されたパスワードが誤っています。";
        break;

      // メール送信頻度が多いと、下記のエラーが発生するため、サインインと同時にメール送信は行わない。
      // Unhandled Exception: [firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.
      case "too-many-requests":
        message = "認証回数が上限に達しました。";
        break;

      //  [firebase_auth/unknown] com.google.firebase.FirebaseException: An internal error has occurred. [ java.security.cert.CertPathValidatorException:Trust anchor for certification path not found. ]
      case "unknown":
        message = "想定外のエラーが発生しました。ネットワークに接続されていることを確認し、改めて操作して下さい。";
        break;

      default:
        message = "想定外のエラーが発生しました。再ログインし直して下さい。";
        break;
    }

    return message;
  }

  return createFirebaseAuthExceptionMessage;
});
