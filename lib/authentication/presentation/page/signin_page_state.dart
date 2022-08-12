import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../authentication_service_firebase.dart';
import '../../usecase/authentication_service_signin_usecase.dart';
import '../widget/login_submit_state.dart';
import '../widget/login_submit_widget.dart';
import '../widget/loginid_field_state.dart';
import '../widget/loginid_field_widget.dart';
import '../widget/password_field_state.dart';
import '../widget/password_field_widget.dart';
import '../widget/signup_widget.dart';

part 'signin_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class SignInPageState with _$SignInPageState {
  const factory SignInPageState._({
    // SignUp Widget
    required Widget singUpWidget,

    // Login Id Field Widget
    required Widget loginIdField,
    required StateNotifierProvider<LoginIdFieldStateNotifier, LoginIdFieldState>
        loginIdFieldStateProvider,

    // Password Field Widget
    required Widget passwordField,
    required StateNotifierProvider<PasswordFieldStateNotifier,
            PasswordFieldState>
        passwordFieldStateProvider,

    // Login Submit Widget
    @Default("サインイン") String loginSubmitWidgetName,
    required Widget loginSubmitWidget,
    required StateNotifierProvider<LoginSubmitStateNotifier, LoginSubmitState>
        loginSubmitStateProvider,
  }) = _SignInPageState;

  factory SignInPageState.create() => SignInPageState._(
        // SignUp Widget
        singUpWidget: const Placeholder(),

        // Login Id Field Widget
        loginIdField: const Placeholder(),
        loginIdFieldStateProvider:
            StateNotifierProvider<LoginIdFieldStateNotifier, LoginIdFieldState>(
                (ref) => LoginIdFieldStateNotifier()),

        // Password Field Widget
        passwordField: const Placeholder(),
        passwordFieldStateProvider: StateNotifierProvider<
            PasswordFieldStateNotifier,
            PasswordFieldState>((ref) => PasswordFieldStateNotifier()),

        // Login Submit
        loginSubmitWidget: const Placeholder(),
        loginSubmitStateProvider:
            StateNotifierProvider<LoginSubmitStateNotifier, LoginSubmitState>(
          (ref) => LoginSubmitStateNotifier(
            loginSubmitWidgetName: "サインイン",
            onSubmit: AuthenticationServiceSignInUsecase(
              authenticationService: AuthenticationServiceFirebase(
                instance: FirebaseAuth.instance,
              ),
            ).execute,
          ),
        ),
      );
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class SignInPageStateNotifier extends StateNotifier<SignInPageState> {
  SignInPageStateNotifier() : super(SignInPageState.create()) {
    rebuild();
  }

  // init
  void initial() {
    state = SignInPageState.create();
  }

  // Rebuild
  void rebuild() {
    buildSignUpWidget();
    buildLoginIdField();
    buildPasswordField();
    buildLoginSubmitWidget();
  }

  // SignUp Widget
  void buildSignUpWidget() {
    const Widget widget = SignUpWidget();

    state = state.copyWith(singUpWidget: widget);
  }

  // Login Id Field Widget
  void buildLoginIdField() {
    Widget widget = LoginIdFieldWidget(
      loginIdFieldstateProvider: state.loginIdFieldStateProvider,
    );

    state = state.copyWith(loginIdField: widget);
  }

  // Password Field Widget
  void buildPasswordField() {
    final Widget widget = PasswordFieldWidget(
      passwordFieldStateProvider: state.passwordFieldStateProvider,
    );

    state = state.copyWith(passwordField: widget);
  }

  // Login Submit Widget
  void buildLoginSubmitWidget() {
    final Widget widget = LoginSubmitWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
      passwordFieldStateProvider: state.passwordFieldStateProvider,
      loginSubmitStateProvider: state.loginSubmitStateProvider,
    );

    state = state.copyWith(loginSubmitWidget: widget);
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final signInPageStateNotifierProvider =
    StateNotifierProvider.autoDispose<SignInPageStateNotifier, SignInPageState>(
  (ref) => SignInPageStateNotifier(),
);
