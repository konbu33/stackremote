import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'authentication_service_state.freezed.dart';
part 'authentication_service_state.g.dart';

@freezed
class AuthenticationServiceState with _$AuthenticationServiceState {
  const factory AuthenticationServiceState._({
    required String loginid,
    required String password,
    @Default(false) bool loggedIn,
  }) = _AuthenticationServiceState;

  factory AuthenticationServiceState.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationServiceStateFromJson(json);

  factory AuthenticationServiceState.create() =>
      const AuthenticationServiceState._(loginid: '', password: '');
}
