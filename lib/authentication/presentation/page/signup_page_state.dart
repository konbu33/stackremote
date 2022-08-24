import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    required StateNotifierProvider<LoginIdFieldStateNotifier, LoginIdFieldState>
        loginIdFieldStateProvider,

    // Password Field Widget
    required StateNotifierProvider<PasswordFieldStateNotifier,
            PasswordFieldState>
        passwordFieldStateProvider,

    // Login Submit Widget
    @Default("新規登録") String loginSubmitWidgetName,
    required StateNotifierProvider<LoginSubmitStateNotifier, LoginSubmitState>
        loginSubmitStateProvider,
  }) = _SignUpPageState;

  factory SignUpPageState.create() => SignUpPageState._(
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
class SignUpPageStateNotifier extends StateNotifier<SignUpPageState> {
  SignUpPageStateNotifier() : super(SignUpPageState.create()) {
  }

  // initial
  void initial() {
    state = SignUpPageState.create();
  }



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
