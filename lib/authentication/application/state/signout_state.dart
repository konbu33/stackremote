import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../infrastructure/authentication_service_firebase.dart';
import '../../infrastructure/authentication_service_if.dart';
import 'authentication_service_state.dart';

part 'signout_state.freezed.dart';

@freezed
class SignOutState with _$SignOutState {
  const factory SignOutState({
    required AuthenticationServiceState authState,
    required AuthenticationServiceIF authenticationService,
    @Default('サインアウト') String signOutButtonName,
  }) = _SignOutState;

  factory SignOutState.initial() => SignOutState(
        authState: AuthenticationServiceState.initial(),
        authenticationService: AuthenticationServiceFirebase(),
      );
}

// class SignOutState {
//   const SignOutState({
//     required this.authState,
//     required this.authenticationService,
//   });

//   // final AsyncValue<AuthenticationServiceState> authState;
//   final AuthenticationServiceState authState;
//   final AuthenticationServiceIF authenticationService;
//   final String signOutButtonName = "Sign Out";
// }
