import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../usecase/authentication_service_signout_usecase.dart';
import '../authentication_service_firebase.dart';

part 'signout_icon_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class SignOutIconState with _$SignOutIconState {
  const factory SignOutIconState._({
    required Function signOut,
    @Default('サインアウト') String signOutWidgetName,
  }) = _SignOutIconState;

  factory SignOutIconState.create() => SignOutIconState._(
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
class SignOutIconStateNotifier extends StateNotifier<SignOutIconState> {
  SignOutIconStateNotifier() : super(SignOutIconState.create());
}

// --------------------------------------------------
//
//  Provider
//
// --------------------------------------------------
final signOutStateProvider = StateNotifierProvider.autoDispose<
    SignOutIconStateNotifier, SignOutIconState>((ref) {
  return SignOutIconStateNotifier();
});
