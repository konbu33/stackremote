import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../common/create_firebse_auth_exception_message.dart';
import '../../usecase/current_user_change_password.dart';
import '../widget/login_submit_state.dart';
import '../widget/password_field_state.dart';

class ChangePasswordPageState {
  // --------------------------------------------------
  //
  //  各password field の validation確認
  //
  // --------------------------------------------------
  static final checkPasswordIsValidateProvider = Provider.autoDispose((ref) {
    //

    bool checkPasswordIsValidate() {
      final passwordIsValidate = ref.watch(passwordFieldStateProvider
          .select((value) => value.passwordIsValidate.isValid));

      final passwordIsValidateConfirm = ref.watch(
          passwordFieldConfirmStateProvider
              .select((value) => value.passwordIsValidate.isValid));

      if (!passwordIsValidate) return false;
      if (!passwordIsValidateConfirm) return false;
      return true;
    }

    return checkPasswordIsValidate;
  });

  // --------------------------------------------------
  //
  //  複数password field 間の入力文字列の一致確認
  //
  // --------------------------------------------------
  static final checkPasswordIsMatchProvider = Provider.autoDispose((ref) {
    //

    bool checkPasswordIsMatch() {
      final passwordFieldState = ref.watch(passwordFieldStateProvider);

      final passwordFieldConfirmState =
          ref.watch(passwordFieldConfirmStateProvider);

      final passwordText = passwordFieldState.passwordFieldController.text;

      final passwordTextConfirm =
          passwordFieldConfirmState.passwordFieldController.text;

      if (passwordText != passwordTextConfirm) return false;
      return true;
    }

    return checkPasswordIsMatch;
  });

  // --------------------------------------------------
  //
  //   passwordFieldStateProvider
  //   passwordFieldConfirmStateProvider
  //
  // --------------------------------------------------

  static final passwordFieldStateProvider =
      passwordFieldStateNotifierProviderCreator();

  static final passwordFieldConfirmStateProvider =
      passwordFieldStateNotifierProviderCreator();

  // --------------------------------------------------
  //
  //   descriptionMessageStateProvider
  //
  // --------------------------------------------------

  // static final descriptionMessageStateProvider =
  //     descriptionMessageStateProviderCreator(
  //   message: "入力間違い防止のため、2回入力して下さい。",
  // );

  static final descriptionMessageStateProvider =
      StateProvider.autoDispose((ref) => "入力間違い防止のため、2回入力して下さい。");

  // --------------------------------------------------
  //
  //   attentionMessageStateProvider
  //
  // --------------------------------------------------
  // static final attentionMessageStateProvider = Provider.autoDispose((ref) {
  //   //

  //   final checkPasswordIsValidate = ref.watch(checkPasswordIsValidateProvider);
  //   final checkPasswordIsMatch = ref.watch(checkPasswordIsMatchProvider);

  //   final passwordIsValidate = checkPasswordIsValidate();

  //   if (!passwordIsValidate) {
  //     return descriptionMessageStateProviderCreator();
  //   }

  //   final passwordIsMatch = checkPasswordIsMatch();

  //   if (!passwordIsMatch) {
  //     const String notMatchMessage = "入力したパスワードが不一致です。";
  //     return descriptionMessageStateProviderCreator(message: notMatchMessage);
  //   }

  //   return descriptionMessageStateProviderCreator();
  // });

  static final attentionMessageStateProvider = StateProvider.autoDispose((ref) {
    //

    // 個別PasswordField毎にvalidate確認
    final checkPasswordIsValidate = ref.watch(checkPasswordIsValidateProvider);
    final passwordIsValidate = checkPasswordIsValidate();

    if (!passwordIsValidate) return "";

    // 複数PasswordField間の入力値の一致確認
    final checkPasswordIsMatch = ref.watch(checkPasswordIsMatchProvider);
    final passwordIsMatch = checkPasswordIsMatch();

    if (!passwordIsMatch) {
      const String notMatchMessage = "入力したパスワードが不一致です。";
      return notMatchMessage;
    }

    return "";
  });

// --------------------------------------------------
//
//   onSubmitStateProvider
//
// --------------------------------------------------
  static const pageTitle = "パスワード変更";

  static final onSubmitStateProvider = Provider.autoDispose((ref) {
    bool passwordIsValidate = false;
    bool passwordIsMatch = false;
    bool isOnSubmitable = false;

    final checkPasswordIsValidate = ref.watch(checkPasswordIsValidateProvider);
    final checkPasswordIsMatch = ref.watch(checkPasswordIsMatchProvider);

    // final attentionMessageStateNotifier =
    //     ref.watch(ref.watch(attentionMessageStateProvider).notifier);

    // --------------------------------------------------
    //  onSubmit関数の生成
    // --------------------------------------------------
    Function? buildChangePasswordOnSubmit() {
      if (!isOnSubmitable) {
        return null;
      }

      return ({
        required BuildContext context,
      }) =>
          () async {
            // メールアドレスにURLを送信し、そのURLを押下してもらい、Firebase側のUIからパスワード変更する。
            // imporve: この方法の方が良い可能性あるため検討の余地あり。
            // final email = ref.read(firebaseAuthUserStateNotifierProvider).email;
            // FirebaseAuth.instance.sendPasswordResetEmail(email: email);

            // アプリ内のUIからパスワード変更する。
            final newPassword = ref
                .read(passwordFieldStateProvider)
                .passwordFieldController
                .text;

            try {
              final currentUserChangePasswordUsecase =
                  ref.read(currentUserChangePasswordUsecaseProvider);

              await currentUserChangePasswordUsecase(
                password: newPassword,
              );

              const String message = "パスワード変更しました。";
              ref
                  .read(attentionMessageStateProvider.notifier)
                  .update((state) => message);
              //

            } on firebase_auth.FirebaseAuthException catch (e) {
              logger.d("$e");

              final createFirebaseExceptionMessage =
                  ref.read(createFirebaseAuthExceptionMessageProvider);

              final String message = createFirebaseExceptionMessage(e);
              ref
                  .read(attentionMessageStateProvider.notifier)
                  .update((state) => message);
            }
          };
    }

    passwordIsValidate = checkPasswordIsValidate();

    if (passwordIsValidate) {
      passwordIsMatch = checkPasswordIsMatch();
    }

    if (passwordIsMatch != isOnSubmitable) {
      isOnSubmitable = passwordIsMatch;
    }

    // logger.d(
    //     "passwordIsValidate : ${passwordIsValidate}, passwordIsMatch : ${passwordIsMatch}, isOnSubmitablei : ${isOnSubmitable}");

    final onSubmitStateProvider = loginSubmitStateNotifierProviderCreator(
      loginSubmitWidgetName: pageTitle,
      onSubmit: buildChangePasswordOnSubmit(),
    );

    return onSubmitStateProvider;
  });
}
