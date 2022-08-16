import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../authentication_service_firebase.dart';
import '../../usecase/authentication_service_signup_usecase.dart';
import '../widget/login_submit_state.dart';
import '../widget/login_submit_widget.dart';
import '../widget/loginid_field_state.dart';
import '../widget/loginid_field_widget.dart';
import '../widget/password_field_state.dart';
import '../widget/password_field_widget.dart';

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
    required Widget loginIdField,
    required StateNotifierProvider<LoginIdFieldStateNotifier, LoginIdFieldState>
        loginIdFieldStateProvider,

    // Password Field Widget
    required Widget passwordField,
    required StateNotifierProvider<PasswordFieldStateNotifier,
            PasswordFieldState>
        passwordFieldStateProvider,

    // Login Submit Widget
    @Default("新規登録") String loginSubmitWidgetName,
    required Widget loginSubmitWidget,
    required StateNotifierProvider<LoginSubmitStateNotifier, LoginSubmitState>
        loginSubmitStateProvider,
  }) = _SignUpPageState;

  factory SignUpPageState.create() => SignUpPageState._(
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
            loginSubmitWidgetName: "新規登録",
            onSubmit: AuthenticationServiceSignUpUsecase(
              authenticationService: AuthenticationServiceFirebase(
                instance: firebase_auth.FirebaseAuth.instance,
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
class SignUpPageStateNotifier extends StateNotifier<SignUpPageState> {
  SignUpPageStateNotifier() : super(SignUpPageState.create()) {
    rebuild();
  }

  // initial
  void initial() {
    state = SignUpPageState.create();
  }

  // Rebuild
  void rebuild() {
    buildLoginIdField();
    buildPasswordField();
    buildLoginSubmitWidget();
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
final signUpPageStateNotifierProvider =
    StateNotifierProvider.autoDispose<SignUpPageStateNotifier, SignUpPageState>(
  (ref) => SignUpPageStateNotifier(),
);
