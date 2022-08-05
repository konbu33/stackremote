import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import '../../domain/value_object/form_state_globalkey.dart';

part 'login_form_state.freezed.dart';
part 'login_form_state.g.dart';

@freezed
class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    // required GlobalKey<FormState> loginFormKey,
    @FormStateGlobalKeyConverter() required FormStateGlobalKey loginFormKey,
  }) = _LoginFormState;

  factory LoginFormState.fromJson(Map<String, dynamic> json) =>
      _$LoginFormStateFromJson(json);

  factory LoginFormState.initial() => LoginFormState(
        loginFormKey: FormStateGlobalKey(GlobalKey<FormState>()),
      );
}
