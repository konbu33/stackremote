import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
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

part 'signin_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class SignInPageState with _$SignInPageState {
  const factory SignInPageState._({
    // GoTo SignUp Submit Widget
    // ignore: unused_element
    @Default("サービス利用登録") String goToSignUpIconOnSubmitWidgetName,
    required AppbarActionIconStateProvider goToSignUpIconStateProvider,

    // Login Id Field Widget
    required LoginIdFieldStateProvider loginIdFieldStateProvider,

    // Password Field Widget
    required PasswordFieldStateProvider passwordFieldStateProvider,

    // Login Submit Widget
    // ignore: unused_element
    @Default("サインイン") String loginSubmitWidgetName,
    required LoginSubmitStateProvider loginSubmitStateProvider,
    // ignore: unused_element
    @Default(false) bool isOnSubmitable,
  }) = _SignInPageState;

  factory SignInPageState.create() => SignInPageState._(
        // GoTo Submit Widget
        goToSignUpIconStateProvider: appbarActionIconStateProviderCreator(
          onSubmitWidgetName: "",
          icon: const Icon(null),
          onSubmit: null,
        ),

        // Login Id Field Widget
        loginIdFieldStateProvider: loginIdFieldStateNotifierProviderCreator(),

        // Password Field Widget
        passwordFieldStateProvider: passwordFieldStateNotifierProviderCreator(),

        // Login Submit
        loginSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
          loginSubmitWidgetName: "",
          onSubmit: null,
        ),
      );
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class SignInPageStateNotifier extends StateNotifier<SignInPageState> {
  SignInPageStateNotifier({
    required this.ref,
  }) : super(SignInPageState.create()) {
    initial();
  }

  // ref
  final Ref ref;

  // initial
  void initial() {
    state = SignInPageState.create();
    setSignInOnSubmit();
    setGoToSignUpIconOnSubmit();
  }

  void updateIsOnSubmitable(
    bool isOnSubmitable,
  ) {
    state = state.copyWith(isOnSubmitable: isOnSubmitable);
  }

  void setSignInOnSubmit() {
    Function? buildOnSubmit() {
      if (!state.isOnSubmitable) {
        return null;
      }

      return ({
        required BuildContext context,
      }) =>
          () async {
            final email = ref
                .read(state.loginIdFieldStateProvider)
                .loginIdFieldController
                .text;
            final password = ref
                .read(state.passwordFieldStateProvider)
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

    state = state.copyWith(
        loginSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
            loginSubmitWidgetName: state.loginSubmitWidgetName,
            onSubmit: buildOnSubmit()));
  }

  void setGoToSignUpIconOnSubmit() {
    Function? buildOnSubmit() {
      return ({
        required BuildContext context,
      }) =>
          () {
            context.push('/signup');
          };
    }

    state = state.copyWith(
      goToSignUpIconStateProvider: appbarActionIconStateProviderCreator(
        onSubmitWidgetName: state.goToSignUpIconOnSubmitWidgetName,
        icon: const Icon(Icons.person_add),
        onSubmit: buildOnSubmit(),
      ),
    );
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final signInPageStateNotifierProvider =
    StateNotifierProvider.autoDispose<SignInPageStateNotifier, SignInPageState>(
  (ref) => SignInPageStateNotifier(ref: ref),
);
