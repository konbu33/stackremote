import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/firebase_auth_user.dart';
import '../../infrastructure/authentication_service_firebase.dart';
import '../../usecase/authentication_service_signup_usecase.dart';
import '../../usecase/verify_email.dart';

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
    @Default("新規登録") String loginSubmitWidgetName,
    required AuthenticationServiceSignUpUsecase
        authenticationServiceSignUpUsecase,
    required LoginSubmitStateProvider loginSubmitStateProvider,
    @Default(false) bool isOnSubmitable,
  }) = _SignUpPageState;

  factory SignUpPageState.create() => SignUpPageState._(
        // Login Id Field Widget
        loginIdFieldStateProvider: loginIdFieldStateNotifierProviderCreator(),

        // Password Field Widget
        passwordFieldStateProvider: passwordFieldStateNotifierProviderCreator(),

        // Login Submit
        authenticationServiceSignUpUsecase: AuthenticationServiceSignUpUsecase(
            authenticationService: AuthenticationServiceFirebase(
                instance: firebase_auth.FirebaseAuth.instance)),

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
              // User情報登録
              final firebase_auth.UserCredential res = await state
                  .authenticationServiceSignUpUsecase
                  .execute(email, password);

              // 登録したUser情報を受取る。
              final firebase_auth.User? user = res.user;

              // User情報取得成功した場合、メールアドレス検証メールを送信
              if (user != null) {
                // print("sendVeryfyEmail Start  ------------------- : ");
                final sendVerifyEmail = ref.read(sendVerifyEmailProvider);
                sendVerifyEmail(user: user);
                // print("sendVeryfyEmail End    ------------------- : ");

                // Userのメールアドレス検証結果を状態で保持する
                final notifier =
                    ref.read(firebaseAuthUserStateNotifierProvider.notifier);
                notifier.updateEmailVerified(user.emailVerified);
              }
            } on firebase_auth.FirebaseAuthException catch (e) {
              // print("e.code : ${e.code}");
              switch (e.code) {
                // User情報が登録済みでエラーになった場合
                case "email-already-in-use":
                  const SnackBar snackBar = SnackBar(
                    content: Text("メールアドレス登録済みです。"),
                  );

                  // User情報が登録済みでエラーになった場合、SnackBarで通知
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  // final checkEmailVerified = ref.read(checkEmailVerifiedProvider);
                  // checkEmailVerified();

                  break;
                default:
              }
            }

            initial();
            // print("initial End    ------------------- : ");
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
