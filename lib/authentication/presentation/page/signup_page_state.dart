import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/common/validation/validator.dart';

import '../../../common/common.dart';
import '../../usecase/current_user_send_verify_email.dart';
import '../../usecase/service_use_registration.dart';

import '../widget/password_field_state.dart';

class SignUpPageState {
  // --------------------------------------------------
  //
  //   loginIdFieldStateProvider
  //   passwordFieldStateProvider
  //   attentionMessageProvider
  //
  // --------------------------------------------------
  // static final loginIdFieldStateProvider =
  //     loginIdFieldStateNotifierProviderCreator();

  static final loginIdFieldStateNotifierProvider = Provider((ref) {
    const name = "メールアドレス";
    final validator = ref.watch(customValidatorProvider);

    final nameFieldStateNotifier = nameFieldStateNotifierProviderCreator(
      name: name,
      validator: validator,
    );

    return nameFieldStateNotifier;
  });

  static final passwordFieldStateProvider =
      passwordFieldStateNotifierProviderCreator();

  static final attentionMessageStateProvider =
      StateProvider.autoDispose((ref) => "");

  // --------------------------------------------------
  //
  //  signUpOnSubmitButtonStateNotifierProvider
  //
  // --------------------------------------------------
  static const pageTitle = "サービス利用登録";

  static final signUpOnSubmitButtonStateNotifierProvider = Provider.autoDispose(
    (ref) {
      bool isOnSubmitable = false;

      final loginIdIsValidate = ref.watch(ref
          .watch(loginIdFieldStateNotifierProvider)
          .select((value) => value.isValidate.isValid));

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
                  .read(ref.read(loginIdFieldStateNotifierProvider))
                  .textEditingController
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
              } on StackremoteException catch (e) {
                ref
                    .read(attentionMessageStateProvider.notifier)
                    .update((state) => e.message);
              }
            };
      }

      if (loginIdIsValidate && passwordIsValidate) {
        isOnSubmitable = true;
      }

      final signUpOnSubmitButtonStateNotifierProvider =
          onSubmitButtonStateNotifierProviderCreator(
        onSubmitButtonWidgetName: pageTitle,
        onSubmit: buildSignUpOnSubmit(),
      );

      return signUpOnSubmitButtonStateNotifierProvider;
    },
  );
}
