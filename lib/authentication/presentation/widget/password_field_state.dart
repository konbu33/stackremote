import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/validation.dart';

part 'password_field_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
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
// StateNotifier
//
// --------------------------------------------------
class PasswordFieldStateNotifier extends StateNotifier<PasswordFieldState> {
  PasswordFieldStateNotifier() : super(PasswordFieldState.create());

  void initial() {
    state = PasswordFieldState.create();
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
        "Min lenght: ${state.passwordMinLength}, Max length : ${state.passwordMaxLength}.";

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
//  typedef Provider
//
// --------------------------------------------------
typedef PasswordFieldStateProvider
    = StateNotifierProvider<PasswordFieldStateNotifier, PasswordFieldState>;

// --------------------------------------------------
//
//  StateNotifierProviderCreator
//
// --------------------------------------------------
Function passwordFieldStateNotifierProviderCreator = () {
  return StateNotifierProvider<PasswordFieldStateNotifier, PasswordFieldState>(
      (ref) => PasswordFieldStateNotifier());
};
