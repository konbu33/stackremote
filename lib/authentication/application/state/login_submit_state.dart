import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../infrastructure/authentication_service_firebase.dart';
import '../../infrastructure/authentication_service_if.dart';
import '../../presentation/widget/loginid_field_notifier.dart';
import '../../presentation/widget/password_field_notifier.dart';

import 'authentication_service_state.dart';
import 'login_form_state.dart';
import 'loginid_field_state.dart';
import 'password_field_state.dart';

part 'login_submit_state.freezed.dart';

@freezed
class LoginSubmitState with _$LoginSubmitState {
  const factory LoginSubmitState({
    required LoginFormState loginFormState,
    required LoginIdFieldState loginIdFieldState,
    required PasswordFieldState passwordFieldState,
    required LoginIdFieldStateNotifier loginIdFieldStateNotifier,
    required PasswordFieldStateNotifier passwordFieldStateNotifier,
    // required final AsyncValue<AuthenticationServiceState> authState,
    required AuthenticationServiceState authState,
    required AuthenticationServiceIF authenticationService,
  }) = _LoginSubmitState;

  factory LoginSubmitState.initial() => LoginSubmitState(
        loginFormState: LoginFormState.initial(),
        loginIdFieldState: LoginIdFieldState.initial(),
        passwordFieldState: PasswordFieldState.initial(),
        loginIdFieldStateNotifier: LoginIdFieldStateNotifier(),
        passwordFieldStateNotifier: PasswordFieldStateNotifier(),
        authState: AuthenticationServiceState.initial(),
        authenticationService: AuthenticationServiceFirebase(),
      );
}

// class LoginSubmitState {
//   const LoginSubmitState({
//     required this.joinFormState,
//     required this.loginIdState,
//     required this.passwordState,
//     required this.loginIdStateNotifier,
//     required this.passwordStateNotifier,
//     required this.authState,
//     required this.authenticationService,
//   });

//   final LoginFormState joinFormState;
//   final LoginIdFieldState loginIdState;
//   final PasswordFieldState passwordState;
//   final LoginIdFieldStateNotifier loginIdStateNotifier;
//   final PasswordFieldStateNotifier passwordStateNotifier;
//   // final AsyncValue<AuthenticationServiceState> authState;
//   final AuthenticationServiceState authState;
//   final AuthenticationServiceIF authenticationService;
// }
