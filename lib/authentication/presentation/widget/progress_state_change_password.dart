import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../usecase/current_user_change_password.dart';
import '../page/change_password_page_state.dart';

// --------------------------------------------------
//
//   progressStateChangePasswordProvider
//
// --------------------------------------------------
final progressStateChangePasswordProvider = Provider((ref) {
  //

  Future<void> changePassword() async {
    void setMessage(String message) {
      ref
          .read(ChangePasswordPageState.attentionMessageStateProvider.notifier)
          .update((state) => "${DateTime.now()}: $message");
    }

    const message = "パスワード変更中";
    setMessage(message);

    // --------------------------------------------------
    //
    // サインアウト
    //
    // --------------------------------------------------
    try {
      // メールアドレスにURLを送信し、そのURLを押下してもらい、Firebase側のUIからパスワード変更する。
      // imporve: この方法の方が良い可能性あるため検討の余地あり。
      // final email = ref.read(firebaseAuthUserStateNotifierProvider).email;
      // FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // アプリ内のUIからパスワード変更する。
      final passwordFieldStateProvider = ref
          .read(ChangePasswordPageState.passwordFieldStateProviderOfProvider);

      final newPassword =
          ref.read(passwordFieldStateProvider).passwordFieldController.text;

      final currentUserChangePasswordUsecase =
          ref.read(currentUserChangePasswordUsecaseProvider);

      await Future.delayed(const Duration(seconds: 1));
      await currentUserChangePasswordUsecase(
        password: newPassword,
      );

      const String message = "パスワード変更しました。";
      setMessage(message);

      //
    } on StackremoteException catch (e) {
      logger.d("$e");
      setMessage(e.message);
    }

    //
  }

  return changePassword;
});
