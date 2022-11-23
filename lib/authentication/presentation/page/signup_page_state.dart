import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../common/create_firebse_auth_exception_message.dart';
import '../../usecase/current_user_send_verify_email.dart';
import '../../usecase/service_use_registration.dart';

import '../widget/login_submit_state.dart';
import '../widget/loginid_field_state.dart';
import '../widget/password_field_state.dart';

class SignUpPageState {
  // --------------------------------------------------
  //
  //   loginIdFieldStateProvider
  //   passwordFieldStateProvider
  //
  // --------------------------------------------------
  static final loginIdFieldStateProvider =
      loginIdFieldStateNotifierProviderCreator();

  static final passwordFieldStateProvider =
      passwordFieldStateNotifierProviderCreator();

  // --------------------------------------------------
  //
  //  loginSubmitStateProvider
  //
  // --------------------------------------------------
  static const loginSubmitWidgetName = "サービス利用登録";

  static final loginSubmitStateProvider = Provider.autoDispose(
    (ref) {
      bool isOnSubmitable = false;

      final loginIdIsValidate = ref.watch(loginIdFieldStateProvider
          .select((value) => value.loginIdIsValidate.isValid));

      final passwordIsValidate = ref.watch(passwordFieldStateProvider
          .select((value) => value.passwordIsValidate.isValid));

      Function? buildSignUpOnSubmit() {
        if (!isOnSubmitable) {
          return null;
        }

        return ({
          required BuildContext context,
        }) =>
            () async {
              final email = ref
                  .read(loginIdFieldStateProvider)
                  .loginIdFieldController
                  .text;

              final password = ref
                  .read(passwordFieldStateProvider)
                  .passwordFieldController
                  .text;

              try {
                // サービス利用登録
                final serviceUseRegistrationUsecase =
                    ref.read(serviceUseRegistrationUsecaseProvider);

                await serviceUseRegistrationUsecase(email, password);

                // メールアドレス検証メール送信
                final currentUserSendVerifyEmailUsecase =
                    ref.read(currentUserSendVerifyEmailUsecaseProvider);

                await currentUserSendVerifyEmailUsecase();

                //
              } on firebase_auth.FirebaseAuthException catch (e) {
                void displayNotificationMessage() {
                  final createFirebaseAuthExceptionMessage =
                      ref.read(createFirebaseAuthExceptionMessageProvider);

                  final buildSnackBarWidget = ref.read(snackBarWidgetProvider);

                  final snackBar =
                      buildSnackBarWidget<firebase_auth.FirebaseAuthException>(
                    e,
                    createFirebaseAuthExceptionMessage,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

                displayNotificationMessage();
              }
            };
      }

      if (loginIdIsValidate && passwordIsValidate) {
        isOnSubmitable = true;
      }

      final loginSubmitStateProvider = loginSubmitStateNotifierProviderCreator(
        loginSubmitWidgetName: loginSubmitWidgetName,
        onSubmit: buildSignUpOnSubmit(),
      );

      return loginSubmitStateProvider;
    },
  );
}
