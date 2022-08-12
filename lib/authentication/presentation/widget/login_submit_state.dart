import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../usecase/authentication_service_signin_usecase.dart';
import '../authentication_service_firebase.dart';

part 'login_submit_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class LoginSubmitState with _$LoginSubmitState {
  const factory LoginSubmitState._({
    // Login Submit Widget
    @Default("サインイン") String loginSubmitWidgetName,
    required Widget loginSubmitWidget,
    required Function signIn,
  }) = _LoginSubmitState;

  factory LoginSubmitState.create() => LoginSubmitState._(
        loginSubmitWidget: const Placeholder(),
        signIn: AuthenticationServiceSignInUsecase(
                authenticationService: AuthenticationServiceFirebase(
                    instance: FirebaseAuth.instance))
            .execute,
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class LoginSubmitStateNotifier extends StateNotifier<LoginSubmitState> {
  LoginSubmitStateNotifier() : super(LoginSubmitState.create());
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final loginSubmitStateNotifierProvider =
    StateNotifierProvider<LoginSubmitStateNotifier, LoginSubmitState>(
        (ref) => LoginSubmitStateNotifier());
