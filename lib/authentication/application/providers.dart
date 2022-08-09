import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../presentation/page/signin_page_state.dart';
import '../presentation/page/signup_page_state.dart';
import '../presentation/widget/login_form_notifier.dart';
import '../presentation/widget/loginid_field_notifier.dart';
import '../presentation/widget/password_field_notifier.dart';
import 'state/login_form_state.dart';

import 'state/login_submit_state.dart';
import '../infrastructure/authentication_service_firebase.dart';

import 'state/loginid_field_state.dart';

import 'state/password_field_state.dart';

import 'state/signout_state.dart';
import 'state/authentication_service_state.dart';

class Providers {
  Providers();

  static final signInFormStateNotifierProvider =
      StateNotifierProvider.autoDispose<LoginFormStateNotifier, LoginFormState>(
          (ref) {
    return LoginFormStateNotifier();
  });

  static final signUpFormStateNotifierProvider =
      StateNotifierProvider.autoDispose<LoginFormStateNotifier, LoginFormState>(
          (ref) {
    return LoginFormStateNotifier();
  });

  static final signInSubmitStateProvider = Provider.autoDispose((ref) {
    return LoginSubmitState(
      loginFormState: ref.watch(Providers.signInFormStateNotifierProvider),
      loginIdFieldState: ref.watch(signInLoginIdFieldStateNotifierProvider),
      passwordFieldState: ref.watch(signInPasswordFieldStateNotifierProvider),
      loginIdFieldStateNotifier:
          ref.read(signInLoginIdFieldStateNotifierProvider.notifier),
      passwordFieldStateNotifier:
          ref.read(signInPasswordFieldStateNotifierProvider.notifier),
      authState: ref.read(authenticationServiceProvider),
      authenticationService: ref.read(authenticationServiceProvider.notifier),
    );
  });

  static final signUpSubmitStateProvider = Provider.autoDispose((ref) {
    return LoginSubmitState(
      loginFormState: ref.watch(Providers.signUpFormStateNotifierProvider),
      loginIdFieldState: ref.watch(signUpLoginIdFieldStateNotifierProvider),
      passwordFieldState: ref.watch(signUpPasswordFieldStateNotifierProvider),
      loginIdFieldStateNotifier:
          ref.read(signUpLoginIdFieldStateNotifierProvider.notifier),
      passwordFieldStateNotifier:
          ref.read(signUpPasswordFieldStateNotifierProvider.notifier),
      authState: ref.read(authenticationServiceProvider),
      authenticationService: ref.read(authenticationServiceProvider.notifier),
    );
  });

  static final signInLoginIdFieldStateNotifierProvider = StateNotifierProvider
      .autoDispose<LoginIdFieldStateNotifier, LoginIdFieldState>((ref) {
    return LoginIdFieldStateNotifier();
  });

  static final signInPasswordFieldStateNotifierProvider = StateNotifierProvider
      .autoDispose<PasswordFieldStateNotifier, PasswordFieldState>((ref) {
    return PasswordFieldStateNotifier();
  });

  static final signUpLoginIdFieldStateNotifierProvider = StateNotifierProvider
      .autoDispose<LoginIdFieldStateNotifier, LoginIdFieldState>((ref) {
    return LoginIdFieldStateNotifier();
  });

  static final signUpPasswordFieldStateNotifierProvider = StateNotifierProvider
      .autoDispose<PasswordFieldStateNotifier, PasswordFieldState>((ref) {
    return PasswordFieldStateNotifier();
  });

  static final signOutStateProvider = Provider.autoDispose((ref) {
    return SignOutState(
      authState: ref.read(authenticationServiceProvider),
      authenticationService: ref.read(authenticationServiceProvider.notifier),
    );
  });

  static final authenticationServiceProvider = StateNotifierProvider<
      AuthenticationServiceFirebase, AuthenticationServiceState>((ref) {
    return AuthenticationServiceFirebase();
  });

  static final useAuthProvider = Provider.autoDispose((ref) {
    print(" ---------------- call useAuthProvider ------------------------- ");
    void useAuth() {
      final state = ref.watch(Providers.authenticationServiceProvider);

      final notifier =
          ref.read(Providers.authenticationServiceProvider.notifier);

      useEffect(() {
        notifier.authStatusChanges().listen((event) {
          print("useAuthProvider auth event : ${event}");
          if (event == null && state.loggedIn) {
            notifier.changeLoggedIn(false);
          } else if (event != null && !state.loggedIn) {
            notifier.changeLoggedIn(true);
          }
        });
      }, []);
    }

    return useAuth;
  });

  static final signUpPageNotifierProvider = StateNotifierProvider.autoDispose<
      SignUpPageStateNotifier, SignUpPageState>((ref) {
    return SignUpPageStateNotifier(
      loginFormState: ref.watch(signUpFormStateNotifierProvider),
      loginIdFieldState: ref.watch(signUpLoginIdFieldStateNotifierProvider),
      loginIdFieldStateNotifier:
          ref.read(signUpLoginIdFieldStateNotifierProvider.notifier),
      passwordFieldState: ref.watch(signUpPasswordFieldStateNotifierProvider),
      passwordFieldStateNotifier:
          ref.read(signUpPasswordFieldStateNotifierProvider.notifier),
      loginSubmitState: ref.watch(signUpSubmitStateProvider),
      onSubmit: ref.read(authenticationServiceProvider.notifier).signUp,
      useAuth: ref.read(useAuthProvider),
    );
  });
}
