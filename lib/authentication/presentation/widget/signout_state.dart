import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/usecase/authentication_service_signout_usecase.dart';

import '../authentication_service_firebase.dart';

part 'signout_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class SignOutState with _$SignOutState {
  const factory SignOutState._({
    required Function signOut,
    @Default('サインアウト') String signOutWidgetName,
  }) = _SignOutState;

  factory SignOutState.create() => SignOutState._(
        signOut: AuthenticationServiceSignOutUsecase(
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
class SignOutStateNotifier extends StateNotifier<SignOutState> {
  SignOutStateNotifier() : super(SignOutState.create());
}

// --------------------------------------------------
//
//  Provider
//
// --------------------------------------------------
final signOutStateProvider =
    StateNotifierProvider.autoDispose<SignOutStateNotifier, SignOutState>(
        (ref) {
  return SignOutStateNotifier();
});
