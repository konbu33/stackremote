import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../common/create_firebse_auth_exception_message.dart';

import '../../usecase/current_user_send_verify_email.dart';
import '../../usecase/service_use_registration.dart';
import '../widget/login_submit_state.dart';
import '../widget/loginid_field_state.dart';
import '../widget/password_field_state.dart';

part 'signup_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class SignUpPageState with _$SignUpPageState {
  const factory SignUpPageState._({
    // Login Id Field Widget
    required LoginIdFieldStateProvider loginIdFieldStateProvider,

    // Password Field Widget
    required PasswordFieldStateProvider passwordFieldStateProvider,

    // Login Submit Widget
    // ignore: unused_element
    @Default("サービス利用登録") String loginSubmitWidgetName,
    required LoginSubmitStateProvider loginSubmitStateProvider,
    // ignore: unused_element
    @Default(false) bool isOnSubmitable,
  }) = _SignUpPageState;

  factory SignUpPageState.create() => SignUpPageState._(
        // Login Id Field Widget
        loginIdFieldStateProvider: loginIdFieldStateNotifierProviderCreator(),

        // Password Field Widget
        passwordFieldStateProvider: passwordFieldStateNotifierProviderCreator(),

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
class SignUpPageStateNotifier extends StateNotifier<SignUpPageState> {
  SignUpPageStateNotifier({
    required this.ref,
  }) : super(SignUpPageState.create()) {
    initial();
  }

  // ref
  final Ref ref;

  // initial
  void initial() {
    state = SignUpPageState.create();
    setSignUpOnSubmit();
  }

  void updateIsOnSubmitable(bool isOnSubmitable) {
    state = state.copyWith(isOnSubmitable: isOnSubmitable);
  }

  void setSignUpOnSubmit() {
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

    state = state.copyWith(
        loginSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
            loginSubmitWidgetName: state.loginSubmitWidgetName,
            onSubmit: buildOnSubmit()));
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final signUpPageStateNotifierProvider =
    StateNotifierProvider.autoDispose<SignUpPageStateNotifier, SignUpPageState>(
  (ref) => SignUpPageStateNotifier(ref: ref),
);
