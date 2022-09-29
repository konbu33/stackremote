import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../usecase/authentication_service_mail_link_auth_usecase.dart';
import '../authentication_service_firebase.dart';
import '../../usecase/authentication_service_signup_usecase.dart';
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
    @Default("新規登録") String loginSubmitWidgetName,
    required AuthenticationServiceSignUpUsecase
        authenticationServiceSignUpUsecase,
    required AuthenticationServiceMailLinkAuthUsecase
        authenticationServiceMailLinkAuthUsecase,
    required LoginSubmitStateProvider loginSubmitStateProvider,
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

        authenticationServiceMailLinkAuthUsecase:
            AuthenticationServiceMailLinkAuthUsecase(
                authenticationService: AuthenticationServiceFirebase(
                    instance: firebase_auth.FirebaseAuth.instance)),

        loginSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
          loginSubmitWidgetName: "",
          onSubmit: () {},
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
    setOnSubmit();
  }

  void setOnSubmit() {
    Function buildOnSubmit() {
      return ({
        required BuildContext context,
      }) async {
        final email = ref
            .read(state.loginIdFieldStateProvider)
            .loginIdFieldController
            .text;
        final password = ref
            .read(state.passwordFieldStateProvider)
            .passwordFieldController
            .text;

        state.authenticationServiceMailLinkAuthUsecase.execute(email);
          // User情報登録
          final firebase_auth.UserCredential res = await state
              .authenticationServiceSignUpUsecase
              .execute(email, password);


        initial();
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
