import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

enum FirebaseAuthExceptionEnum {
  // --------------------------------------------------
  //
  // コンストラクタを利用したEnum定義
  //
  // --------------------------------------------------

  // SignUp
  // [firebase_auth/email-already-in-use] The email address is already in use by another account.
  emailAlreadyInUse(
    code: "email-already-in-use",
    message: "メールアドレス登録済みです。",
  ),

  // SignIn
  // [firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.
  userNotFound(
    code: "user-not-found",
    message: "メールアドレス未登録です。",
  ),

  //  [firebase_auth/wrong-password] The password is invalid or the user does not have a password.
  wrongPassword(
    code: "wrong-password",
    message: "入力されたパスワードが誤っています。",
  ),

  //  [firebase_auth/invalid-email] The email address is badly formatted.
  invalidEmail(
    code: "invalid-email",
    message: "メールアドレスを入力して下さい。",
  ),

  // メール送信頻度が多いと、下記のエラーが発生するため、サインインと同時にメール送信は行わない。
  // Unhandled Exception: [firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.
  tooManyRequests(
    code: "too-many-requests",
    message: "一定期間内に、複数回メール送信されたため、メール送信を制限しました。しばらく時間を空けてから改めて操作して下さい。",
  ),

  //  [firebase_auth/unknown] com.google.firebase.FirebaseException: An internal error has occurred. [ java.security.cert.CertPathValidatorException:Trust anchor for certification path not found. ]
  unknown(
    code: "unknown",
    message: "想定外のエラーが発生しました。ネットワークに接続されていることを確認し、改めて操作して下さい。",
  ),

  // パスワード変更、FirebaseAuthユーザ削除
  // Unhandled Exception: [firebase_auth/requires-recent-login] This operation is sensitive and requires recent authentication. Log in again before retrying this request.
  requiresRecentLogin(
    code: "requires-recent-login",
    message: "前回のログインから一定時間が経過しているため、再ログインした後、改めて操作を行って下さい。",
  ),

  alreadyEmailVerified(
    code: "already-email-verified",
    message: "既にメールアドレス検証済みです。",
  ),

  currentUserNull(
    code: "current-user-null",
    message: "currentUserの情報が不明です。",
  ),

  unexpectedError(
    code: "unexpected-error",
    message: "想定外のエラーが発生しました。",
  );

  // --------------------------------------------------
  //
  // コンストラクタ
  // メンバ変数
  //
  // --------------------------------------------------
  const FirebaseAuthExceptionEnum({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  // --------------------------------------------------
  //
  // メソッド
  //
  // --------------------------------------------------
  static String messageToJapanese(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {

      // SignUp
      case "email-already-in-use":
        return FirebaseAuthExceptionEnum.emailAlreadyInUse.message;

      // SignIn
      case "user-not-found":
        return FirebaseAuthExceptionEnum.userNotFound.message;

      case "wrong-password":
        return FirebaseAuthExceptionEnum.wrongPassword.message;

      case "invalid-email":
        return FirebaseAuthExceptionEnum.invalidEmail.message;

      case "too-many-requests":
        return FirebaseAuthExceptionEnum.tooManyRequests.message;

      case "unknown":
        return FirebaseAuthExceptionEnum.unknown.message;

      case "requires-recent-login":
        return FirebaseAuthExceptionEnum.requiresRecentLogin.message;

      // 独自
      case "already-email-verified":
        return FirebaseAuthExceptionEnum.alreadyEmailVerified.message;

      case "current-user-null":
        return FirebaseAuthExceptionEnum.currentUserNull.message;

      default:
        return FirebaseAuthExceptionEnum.unexpectedError.message;
    }
  }
}
