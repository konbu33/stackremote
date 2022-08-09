import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers.dart';
import '../../application/state/login_form_state.dart';
import '../../application/state/login_submit_state.dart';
import '../../application/state/loginid_field_state.dart';
import '../../application/state/password_field_state.dart';
import '../widget/loginid_field_notifier.dart';
import '../widget/password_field_notifier.dart';

part 'signup_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class SignUpPageState with _$SignUpPageState {
  factory SignUpPageState._({
    required LoginFormState loginFormState,
    required LoginIdFieldState loginIdFieldState,
    required LoginIdFieldStateNotifier loginIdFieldStateNotifier,
    required PasswordFieldState passwordFieldState,
    required PasswordFieldStateNotifier passwordFieldStateNotifier,
    required LoginSubmitState loginSubmitState,
    required Function onSubmit,
    required Function useAuth,
    @Default("新規登録") String title,
  }) = _SignUpPageState;
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class SignUpPageStateNotifier extends StateNotifier<SignUpPageState> {
  SignUpPageStateNotifier({
    required LoginFormState loginFormState,
    required LoginIdFieldState loginIdFieldState,
    required LoginIdFieldStateNotifier loginIdFieldStateNotifier,
    required PasswordFieldState passwordFieldState,
    required PasswordFieldStateNotifier passwordFieldStateNotifier,
    required LoginSubmitState loginSubmitState,
    required Function onSubmit,
    required Function useAuth,
  }) : super(
          SignUpPageState._(
            loginFormState: loginFormState,
            loginIdFieldState: loginIdFieldState,
            loginIdFieldStateNotifier: loginIdFieldStateNotifier,
            passwordFieldState: passwordFieldState,
            passwordFieldStateNotifier: passwordFieldStateNotifier,
            loginSubmitState: loginSubmitState,
            onSubmit: onSubmit,
            useAuth: useAuth,
          ),
        );
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final signUpPageNotifierProvider =
    StateNotifierProvider.autoDispose<SignUpPageStateNotifier, SignUpPageState>(
        (ref) {
  return SignUpPageStateNotifier(
    loginFormState: ref.watch(Providers.signUpFormStateNotifierProvider),
    loginIdFieldState:
        ref.watch(Providers.signUpLoginIdFieldStateNotifierProvider),
    loginIdFieldStateNotifier:
        ref.read(Providers.signUpLoginIdFieldStateNotifierProvider.notifier),
    passwordFieldState:
        ref.watch(Providers.signUpPasswordFieldStateNotifierProvider),
    passwordFieldStateNotifier:
        ref.read(Providers.signUpPasswordFieldStateNotifierProvider.notifier),
    loginSubmitState: ref.watch(Providers.signUpSubmitStateProvider),
    onSubmit: ref.read(Providers.authenticationServiceProvider.notifier).signUp,
    useAuth: ref.read(Providers.useAuthProvider),
  );
});
