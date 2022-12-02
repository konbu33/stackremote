import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../usecase/service_signin.dart';

import '../widget/loginid_field_state.dart';
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
  static final loginIdFieldStateProvider =
      loginIdFieldStateNotifierProviderCreator();

  static final passwordFieldStateProvider =
      passwordFieldStateNotifierProviderCreator();

  static final isSignUpPagePushProvider = StateProvider((ref) => false);

  static final attentionMessageStateProvider =
      StateProvider.autoDispose((ref) => "");

  // --------------------------------------------------
  //
  //  loginSubmitStateProvider
  //
  // --------------------------------------------------
  static const loginSubmitWidgetName = "サインイン";

  static final loginSubmitStateProvider = Provider.autoDispose(
    (ref) {
      bool isOnSubmitable = false;

      final loginIdIsValidate = ref.watch(loginIdFieldStateProvider
          .select((value) => value.loginIdIsValidate.isValid));

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
                  .read(loginIdFieldStateProvider)
                  .loginIdFieldController
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

      final loginSubmitStateNotifierProvider =
          onSubmitButtonStateNotifierProviderCreator(
        onSubmitButtonWidgetName: loginSubmitWidgetName,
        onSubmit: buildSignInOnSubmit(),
      );

      return loginSubmitStateNotifierProvider;
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
