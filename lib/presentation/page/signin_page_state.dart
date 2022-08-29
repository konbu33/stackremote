import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../authentication_service_firebase.dart';
import '../../usecase/authentication_service_signin_usecase.dart';
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
    @Default("新規登録") String goToSignUpIconOnSubmitWidgetName,
    required AppbarActionIconStateProvider goToSignUpIconStateProvider,

    // Login Id Field Widget
    required LoginIdFieldStateProvider loginIdFieldStateProvider,

    // Password Field Widget
    required PasswordFieldStateProvider passwordFieldStateProvider,

    // Login Submit Widget
    @Default("サインイン") String loginSubmitWidgetName,
    required AuthenticationServiceSignInUsecase
        authenticationServiceSignInUsecase,
    required LoginSubmitStateProvider loginSubmitStateProvider,
  }) = _SignInPageState;

  factory SignInPageState.create() => SignInPageState._(
        // GoTo Submit Widget
        goToSignUpIconStateProvider: appbarActionIconStateProviderCreator(
          onSubmitWidgetName: "",
          icon: const Icon(null),
          onSubmit: () {},
        ),

        // Login Id Field Widget
        loginIdFieldStateProvider: loginIdFieldStateNotifierProviderCreator(),

        // Password Field Widget
        passwordFieldStateProvider: passwordFieldStateNotifierProviderCreator(),

        // Login Submit
        authenticationServiceSignInUsecase: AuthenticationServiceSignInUsecase(
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

  void setSignInOnSubmit() {
    Function buildOnSubmit() {
      return ({
        required BuildContext context,
      }) {
        final email = ref
            .read(state.loginIdFieldStateProvider)
            .loginIdFieldController
            .text;
        final password = ref
            .read(state.passwordFieldStateProvider)
            .passwordFieldController
            .text;

        state.authenticationServiceSignInUsecase.execute(email, password);

        initial();
      };
    }

    state = state.copyWith(
        loginSubmitStateProvider: loginSubmitStateNotifierProviderCreator(
            loginSubmitWidgetName: state.loginSubmitWidgetName,
            onSubmit: buildOnSubmit()));
  }

  void setGoToSignUpIconOnSubmit() {
    Function buildOnSubmit() {
      return ({
        required BuildContext context,
      }) {
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
