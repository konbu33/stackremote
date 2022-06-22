import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/state/login_form_state.dart';
import '../../application/state/login_submit_state.dart';
import '../../application/state/loginid_field_state.dart';
import '../../application/state/password_field_state.dart';
import '../widget/loginid_field_notifier.dart';
import '../widget/password_field_notifier.dart';

part 'signin_page_state.freezed.dart';

@freezed
class SignInPageState with _$SignInPageState {
  const factory SignInPageState({
    required LoginFormState loginFormState,
    required LoginIdFieldState loginIdFieldState,
    required LoginIdFieldStateNotifier loginIdFieldStateNotifier,
    required PasswordFieldState passwordFieldState,
    required PasswordFieldStateNotifier passwordFieldStateNotifier,
    required LoginSubmitState loginSubmitState,
    required Function onSubmit,
    required Function useAuth,
    @Default("サインイン") String title,
  }) = _SignInPageState;

  factory SignInPageState.initial({
    required LoginFormState loginFormState,
    required LoginIdFieldState loginIdFieldState,
    required LoginIdFieldStateNotifier loginIdFieldStateNotifier,
    required PasswordFieldState passwordFieldState,
    required PasswordFieldStateNotifier passwordFieldStateNotifier,
    required LoginSubmitState loginSubmitState,
    required Function onSubmit,
    required Function useAuth,
  }) =>
      SignInPageState(
        loginFormState: loginFormState,
        loginIdFieldState: loginIdFieldState,
        loginIdFieldStateNotifier: loginIdFieldStateNotifier,
        passwordFieldState: passwordFieldState,
        passwordFieldStateNotifier: passwordFieldStateNotifier,
        loginSubmitState: loginSubmitState,
        onSubmit: onSubmit,
        useAuth: useAuth,
      );
}
