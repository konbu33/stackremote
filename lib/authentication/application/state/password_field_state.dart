import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/value_object/form_field_state_globalkey.dart';
import '../../domain/value_object/login_icon.dart';
import '../../domain/value_object/login_text_editing_controller.dart';

part 'password_field_state.freezed.dart';
part 'password_field_state.g.dart';

@freezed
class PasswordFieldState with _$PasswordFieldState {
  const factory PasswordFieldState({
    // required GlobalKey<FormFieldState> passwordKey,
    @FormFieldStateGlobalKeyConverter()
        required FormFieldStateGlobalKey passwordKey,
    // required TextEditingController passwordController,
    @LoginTextEditingControllerConverter()
        required LoginTextEditingController passwordController,
    // @Default(Icon(Icons.key)) Icon passwordIcon,
    @LoginIconConverter() required LoginIcon passwordIcon,
    @Default("パスワード") String passwordFieldName,
    @Default(true) bool isObscure,
    @Default(false) bool isSubmitable,
    @Default(false) bool validateSuccess,
    @Default(8) int minLength,
    @Default(20) int maxLength,
    @Default("") String validatorMessage,
  }) = _PasswordFieldState;

  factory PasswordFieldState.fromJson(Map<String, dynamic> json) =>
      _$PasswordFieldStateFromJson(json);

  factory PasswordFieldState.initial() {
    return PasswordFieldState(
      passwordKey: FormFieldStateGlobalKey(value: GlobalKey<FormFieldState>()),
      passwordController:
          LoginTextEditingController(value: TextEditingController()),
      passwordIcon: const LoginIcon(value: Icon(Icons.key)),
    );
  }
}
