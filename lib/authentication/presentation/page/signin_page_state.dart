import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/common/validation/validator.dart';

import '../../../common/common.dart';

import '../../usecase/service_signin.dart';

import '../widget/password_field_state.dart';

class SignInPageState {
  // --------------------------------------------------
  //
  //  loginIdFieldStateProvider
  //  passwordFieldStateProvider
  //  isSignUpPagePushProvider
  //  attentionMessageProvider
  //
  // --------------------------------------------------
  // static final loginIdFieldStateProvider =
  //     loginIdFieldStateNotifierProviderCreator();

  static final loginIdFieldStateNotifierProviderOfProvider =
      StateProvider.autoDispose((ref) {
    NameFieldStateNotifierProvider loginIdFieldStateNotifierProviderCreator() {
      const name = "メールアドレス";

      const minMax = MinMax(min: 8, max: 20);
      final minMaxLenghtValidator =
          ref.watch(minMaxLenghtValidatorProvider(minMax));

      final nameFieldStateNotifierProvider =
          nameFieldStateNotifierProviderCreator(
        name: name,
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

  static final isSignUpPagePushProvider = StateProvider((ref) => false);

  static final attentionMessageStateProvider =
      StateProvider.autoDispose((ref) => "");

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

      Function? buildSignInOnSubmit() {
        if (!isOnSubmitable) {
          return null;
        }

        return ({
          required BuildContext context,
        }) =>
            () async {
              final email = ref
                  .read(loginIdFieldStateNotifierProvider)
                  .textEditingController
                  .text;

              final password = ref
                  .read(passwordFieldStateProvider)
                  .passwordFieldController
                  .text;

              try {
                // サインイン
                final serviceSignInUsecase =
                    ref.read(serviceSignInUsecaseProvider);

                await serviceSignInUsecase(email, password);

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

      final signInOnSubmitButtonStateNotifierProvider =
          onSubmitButtonStateNotifierProviderCreator(
        onSubmitButtonWidgetName: pageTitle,
        onSubmit: buildSignInOnSubmit(),
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

    void Function() buildGoToSignUpIconOnSubmit() {
      return () {
        ref.read(isSignUpPagePushProvider.notifier).update((state) => true);
      };
    }

    final appbarActionIconState = AppbarActionIconState.create(
      onSubmitWidgetName: "サービス利用登録",
      icon: const Icon(Icons.person_add),
      onSubmit: buildGoToSignUpIconOnSubmit,
    );

    final appbarActionIconStateProvider =
        appbarActionIconStateNotifierProviderCreator(
      appbarActionIconState: appbarActionIconState,
    );

    return appbarActionIconStateProvider;
  });
}
