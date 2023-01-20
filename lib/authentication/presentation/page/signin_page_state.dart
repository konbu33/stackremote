import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../authentication_routing_layer.dart';
import '../widget/password_field_state.dart';
import '../widget/progress_state_signin.dart';

class SignInPageState {
  // --------------------------------------------------
  //
  //  loginIdFieldStateProvider
  //  passwordFieldStateProvider
  //  attentionMessageProvider
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
  //  signInProgressStateNotifierProviderOfProvider
  //
  // --------------------------------------------------
  static final signInProgressStateNotifierProviderOfProvider =
      Provider.autoDispose((ref) {
    final function = ref.watch(progressStateSignInProvider);

    return progressStateNotifierProviderCreator(function: function);
  });

  // --------------------------------------------------
  //
  //  signInOnSubmitButtonStateNotifierProvider
  //
  // --------------------------------------------------
  static const pageTitle = "サインイン";

  static final signInOnSubmitButtonStateNotifierProvider = Provider.autoDispose(
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

      void Function()? buildSignInOnSubmit() {
        if (!isOnSubmitable) {
          return null;
        }

        return () async {
          final signInProgressStateNotifierProvider =
              ref.read(signInProgressStateNotifierProviderOfProvider);

          ref
              .read(signInProgressStateNotifierProvider.notifier)
              .updateProgress();
        };
      }

      if (loginIdIsValidate && passwordIsValidate) {
        isOnSubmitable = true;
      }

      final signInOnSubmitButtonStateNotifierProvider =
          onSubmitButtonStateNotifierProviderCreator(
        onSubmitButtonWidgetName: pageTitle,
        onSubmit: buildSignInOnSubmit,
      );

      return signInOnSubmitButtonStateNotifierProvider;
    },
  );

  // --------------------------------------------------
  //
  //  goToSignUpIconStateProvider
  //
  // --------------------------------------------------

  static final goToSignUpIconStateProvider = Provider((ref) {
    //

    AppbarActionIconOnSubmitFunction buildGoToSignUpIconOnSubmit() {
      return ({required BuildContext context}) => () {
            context.go(AuthenticationRoutingPath.signInSignUp.path);
          };
    }

    final appbarActionIconState = AppbarActionIconState.create(
      onSubmitWidgetName: "サービス利用登録",
      icon: const Icon(Icons.person_add),
      onSubmit: buildGoToSignUpIconOnSubmit(),
    );

    final appbarActionIconStateProvider =
        appbarActionIconStateNotifierProviderCreator(
      appbarActionIconState: appbarActionIconState,
    );

    return appbarActionIconStateProvider;
  });
}
