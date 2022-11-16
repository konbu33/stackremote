import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../common/create_firebse_auth_exception_message.dart';
import '../../usecase/service_signin.dart';

import '../widget/appbar_action_icon_state.dart';
import '../widget/login_submit_state.dart';
import '../widget/loginid_field_state.dart';
import '../widget/password_field_state.dart';

// --------------------------------------------------
//
//  loginSubmitWidgetNameProvider
//
// --------------------------------------------------
final loginSubmitWidgetNameProvider = StateProvider((ref) {
  const loginSubmitWidgetName = "サインイン";
  return loginSubmitWidgetName;
});

// --------------------------------------------------
//
//  goToSignUpIconOnSubmitWidgetNameProvider
//
// --------------------------------------------------
final goToSignUpIconOnSubmitWidgetNameProvider = StateProvider((ref) {
  const goToSignUpIconOnSubmitWidgetName = "サービス利用登録";
  return goToSignUpIconOnSubmitWidgetName;
});

// --------------------------------------------------
//
//  goToSignUpIconStateProvider
//
// --------------------------------------------------

final goToSignUpIconStateProvider = Provider((ref) {
  final goToSignUpIconOnSubmitWidgetName =
      ref.watch(goToSignUpIconOnSubmitWidgetNameProvider);

  Function? buildGoToSignUpIconOnSubmit() {
    return ({
      required BuildContext context,
    }) =>
        () {
          context.push('/signup');
        };
  }

  final appbarActionIconStateProvider = appbarActionIconStateProviderCreator(
    onSubmitWidgetName: goToSignUpIconOnSubmitWidgetName,
    icon: const Icon(Icons.person_add),
    onSubmit: buildGoToSignUpIconOnSubmit(),
  );

  return appbarActionIconStateProvider;
});

// --------------------------------------------------
//
//  loginIdFieldStateProvider
//
// --------------------------------------------------
final loginIdFieldStateProvider = loginIdFieldStateNotifierProviderCreator();

// --------------------------------------------------
//
//  passwordFieldStateProvider
//
// --------------------------------------------------
final passwordFieldStateProvider = passwordFieldStateNotifierProviderCreator();

// --------------------------------------------------
//
//  loginSubmitStateProvider
//
// --------------------------------------------------
final loginSubmitStateProvider = Provider.autoDispose(
  (ref) {
    final loginIdIsValidate = ref.watch(loginIdFieldStateProvider
        .select((value) => value.loginIdIsValidate.isValid));

    final passwordIsValidate = ref.watch(passwordFieldStateProvider
        .select((value) => value.passwordIsValidate.isValid));

    final loginSubmitWidgetName = ref.watch(loginSubmitWidgetNameProvider);

    Function? buildSignInOnSubmit() {
      if (!(loginIdIsValidate && passwordIsValidate)) {
        return null;
      }

      return ({
        required BuildContext context,
      }) =>
          () async {
            final email =
                ref.read(loginIdFieldStateProvider).loginIdFieldController.text;

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
            } on firebase_auth.FirebaseAuthException catch (e) {
              logger.d("$e");

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

    final LoginSubmitStateProvider loginSubmitStateNotifierProvider;

    if (loginIdIsValidate && passwordIsValidate) {
      loginSubmitStateNotifierProvider =
          loginSubmitStateNotifierProviderCreator(
        loginSubmitWidgetName: loginSubmitWidgetName,
        onSubmit: buildSignInOnSubmit(),
      );
    } else {
      loginSubmitStateNotifierProvider =
          loginSubmitStateNotifierProviderCreator(
        loginSubmitWidgetName: loginSubmitWidgetName,
        onSubmit: null,
      );
    }

    return loginSubmitStateNotifierProvider;
  },
);
