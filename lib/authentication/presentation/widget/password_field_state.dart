import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

part 'password_field_state.freezed.dart';

// --------------------------------------------------
//
// PasswordFieldState
//
// --------------------------------------------------
@freezed
class PasswordFieldState with _$PasswordFieldState {
  const factory PasswordFieldState._({
    // ignore: unused_element
    @Default("パスワード") String passwordFieldName,
    required Widget passwordField,
    required GlobalKey<FormFieldState> passwordFieldKey,
    required FocusNode focusNode,
    required TextEditingController passwordFieldController,
    required Icon passwordIcon,
    required Validation passwordIsValidate,
    // ignore: unused_element
    @Default(8) int passwordMinLength,
    // ignore: unused_element
    @Default(20) int passwordMaxLength,
    // ignore: unused_element
    @Default(true) bool passwordIsObscure,
  }) = _PasswordFieldState;

  factory PasswordFieldState.create() {
    return PasswordFieldState._(
      passwordField: const Placeholder(),
      passwordFieldKey: GlobalKey<FormFieldState>(),
      focusNode: FocusNode(),
      passwordFieldController: TextEditingController(),
      passwordIcon: const Icon(Icons.key),
      passwordIsValidate: Validation.create(),
    );
  }
}

// --------------------------------------------------
//
// PasswordFieldStateNotifier
//
// --------------------------------------------------
class PasswordFieldStateNotifier extends Notifier<PasswordFieldState> {
  @override
  PasswordFieldState build() {
    final passwordFieldState = PasswordFieldState.create();
    return passwordFieldState;
  }

  void setUserPassword(String value) {
    state = state.copyWith(
        passwordFieldController: TextEditingController(text: value));
  }

  void passwordToggleObscureText() {
    state = state.copyWith(passwordIsObscure: !state.passwordIsObscure);
  }

  Validation passwordCustomValidator(String value) {
    const defaultMessage = "";
    const emptyMessage = "";

    final minMaxLenghtMessage =
        "${state.passwordMinLength}文字以上、${state.passwordMaxLength}文字以下で入力して下さい。";

    if (value.isEmpty) {
      final validation =
          Validation.create(isValid: false, message: emptyMessage);
      state = state.copyWith(passwordIsValidate: validation);
      return validation;
    }
    if (value.length < state.passwordMinLength) {
      final validation =
          Validation.create(isValid: false, message: minMaxLenghtMessage);
      state = state.copyWith(passwordIsValidate: validation);
      return validation;
    }
    final validation =
        Validation.create(isValid: true, message: defaultMessage);

    state = state.copyWith(passwordIsValidate: validation);
    return validation;
  }
}

// --------------------------------------------------
//
//  passwordFieldStateNotifierProviderCreator
//
// --------------------------------------------------
typedef PasswordFieldStateProvider
    = NotifierProvider<PasswordFieldStateNotifier, PasswordFieldState>;

PasswordFieldStateProvider passwordFieldStateNotifierProviderCreator() {
  return NotifierProvider<PasswordFieldStateNotifier, PasswordFieldState>(
      () => PasswordFieldStateNotifier());
}
