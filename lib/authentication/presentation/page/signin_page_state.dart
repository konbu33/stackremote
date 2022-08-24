import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../authentication_service_firebase.dart';
import '../../usecase/authentication_service_signin_usecase.dart';
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
    // Login Id Field Widget
    required StateNotifierProvider<LoginIdFieldStateNotifier, LoginIdFieldState>
        loginIdFieldStateProvider,

    // Password Field Widget
    required StateNotifierProvider<PasswordFieldStateNotifier,
            PasswordFieldState>
        passwordFieldStateProvider,

    // Login Submit Widget
    @Default("サインイン") String loginSubmitWidgetName,
    required StateNotifierProvider<LoginSubmitStateNotifier, LoginSubmitState>
        loginSubmitStateProvider,
  }) = _SignInPageState;

  factory SignInPageState.create() => SignInPageState._(
        // Login Id Field Widget
        loginIdFieldStateProvider: loginIdFieldStateNotifierProviderCreator(),

        // Password Field Widget
        passwordFieldStateProvider: passwordFieldStateNotifierProviderCreator(),

        // Login Submit
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
  SignInPageStateNotifier() : super(SignInPageState.create()) {
  }

  // initial
  void initial() {
    state = SignInPageState.create();
  }



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
