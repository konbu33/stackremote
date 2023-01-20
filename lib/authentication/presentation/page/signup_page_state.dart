import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../widget/password_field_state.dart';
import '../widget/progress_state_signup.dart';

class SignUpPageState {
  // --------------------------------------------------
  //
  //   loginIdFieldStateNotifierProviderOfProvider
  //   passwordFieldStateProviderOfProvider
  //   attentionMessageProvider
  //
  // --------------------------------------------------

  static final loginIdFieldStateNotifierProviderOfProvider =
      StateProvider.autoDispose((ref) {
    NameFieldStateNotifierProvider loginIdFieldStateNotifierProviderCreator() {
      const name = "メールアドレス";

      final minMax = MinMax<int>.create(min: 8, max: 20);
      final minMaxLenghtValidator =
          ref.watch(minMaxLenghtValidatorProvider(minMax));

      final nameFieldStateNotifierProvider =
          nameFieldStateNotifierProviderCreator(
        name: name,
        icon: const Icon(Icons.email_sharp),
        validator: minMaxLenghtValidator,
        minLength: minMax.min,
        maxLength: minMax.max,
      );

      return nameFieldStateNotifierProvider;
    }

    return loginIdFieldStateNotifierProviderCreator();
  });

  static final passwordFieldStateProviderOfProvider = StateProvider.autoDispose(
      (ref) => passwordFieldStateNotifierProviderCreator());

  static final attentionMessageStateProvider =
      StateProvider.autoDispose((ref) => "");

  // --------------------------------------------------
  //
  //  signUpProgressStateNotifierProviderOfProvider
  //
  // --------------------------------------------------
  static final signUpProgressStateNotifierProviderOfProvider =
      Provider.autoDispose((ref) {
    final function = ref.watch(progressStateSignUpProvider);

    return progressStateNotifierProviderCreator(function: function);
  });

  // --------------------------------------------------
  //
  //  signUpOnSubmitButtonStateNotifierProvider
  //
  // --------------------------------------------------
  static const pageTitle = "サービス利用登録";

  static final signUpOnSubmitButtonStateNotifierProvider = Provider.autoDispose(
    (ref) {
      bool isOnSubmitable = false;

      final loginIdFieldStateNotifierProvider =
          ref.watch(loginIdFieldStateNotifierProviderOfProvider);

      final loginIdIsValidate = ref.watch(loginIdFieldStateNotifierProvider
          .select((value) => value.isValidate.isValid));

      final passwordFieldStateProvider =
          ref.watch(passwordFieldStateProviderOfProvider);

      final passwordIsValidate = ref.watch(passwordFieldStateProvider
          .select((value) => value.passwordIsValidate.isValid));

      void Function()? buildSignUpOnSubmit() {
        if (!isOnSubmitable) {
          return null;
        }

        return () async {
          final signUpProgressStateNotifierProvider =
              ref.read(signUpProgressStateNotifierProviderOfProvider);

          ref
              .read(signUpProgressStateNotifierProvider.notifier)
              .updateProgress();
        };
      }

      if (loginIdIsValidate && passwordIsValidate) {
        isOnSubmitable = true;
      }

      final signUpOnSubmitButtonStateNotifierProvider =
          onSubmitButtonStateNotifierProviderCreator(
        onSubmitButtonWidgetName: pageTitle,
        onSubmit: buildSignUpOnSubmit,
      );

      return signUpOnSubmitButtonStateNotifierProvider;
    },
  );
}
