import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/value_object/form_field_state_globalkey.dart';
import '../../domain/value_object/login_icon.dart';
import '../../domain/value_object/login_text_editing_controller.dart';

part 'loginid_field_state.freezed.dart';
part 'loginid_field_state.g.dart';

@freezed
class LoginIdFieldState with _$LoginIdFieldState {
  const factory LoginIdFieldState({
    // required GlobalKey<FormFieldState> loginidKey,
    @FormFieldStateGlobalKeyConverter()
        required FormFieldStateGlobalKey loginidKey,
    // required TextEditingController loginidController,
    @LoginTextEditingControllerConverter()
        required LoginTextEditingController loginidController,
    // @Default(Icon(Icons.mail)) Icon loginIdIcon,
    @LoginIconConverter() required LoginIcon loginIdIcon,
    @Default("メールアドレス") String loginFieldName,
    @Default(false) bool isSubmitable,
    @Default(false) bool validateSuccess,
    @Default(8) int minLength,
    @Default(20) int maxLength,
    @Default("") String validatorMessage,
  }) = _LoginIdFieldState;

  factory LoginIdFieldState.fromJson(Map<String, dynamic> json) =>
      _$LoginIdFieldStateFromJson(json);

  factory LoginIdFieldState.initial() {
    return LoginIdFieldState(
      loginidKey: FormFieldStateGlobalKey(value: GlobalKey<FormFieldState>()),
      loginidController:
          LoginTextEditingController(value: TextEditingController()),
      loginIdIcon: const LoginIcon(value: Icon(Icons.mail)),
    );
  }
}
