import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../common/validation.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'loginid_field_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class LoginIdFieldState with _$LoginIdFieldState {
  const factory LoginIdFieldState._({
    // ignore: unused_element
    @Default("メールアドレス") String loginIdFieldName,
    required Widget loginIdField,
    required GlobalKey<FormFieldState> loginIdFieldKey,
    required TextEditingController loginIdFieldController,
    required Icon loginIdIcon,
    required Validation loginIdIsValidate,
    // ignore: unused_element
    @Default(8) int loginIdMinLength,
    // ignore: unused_element
    @Default(20) int loginIdMaxLength,
  }) = _LoginIdFieldState;

  factory LoginIdFieldState.create() {
    return LoginIdFieldState._(
      loginIdField: const Placeholder(),
      loginIdFieldKey: GlobalKey<FormFieldState>(),
      loginIdFieldController: TextEditingController(),
      loginIdIcon: const Icon(Icons.mail),
      loginIdIsValidate: Validation.create(),
    );
  }
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class LoginIdFieldStateNotifier extends StateNotifier<LoginIdFieldState> {
  LoginIdFieldStateNotifier() : super(LoginIdFieldState.create());

  void initial() {
    state = LoginIdFieldState.create();
  }

  void setUserEmail(String value) {
    state = state.copyWith(
        loginIdFieldController: TextEditingController(text: value));
  }

  Validation loginIdCustomValidator(String value) {
    const defaultMessage = "";
    const emptyMessage = "";
    final minMaxLenghtMessage =
        "Min lenght: ${state.loginIdMinLength}, Max length : ${state.loginIdMaxLength}.";

    if (value.isEmpty) {
      final validation =
          Validation.create(isValid: false, message: emptyMessage);
      state = state.copyWith(loginIdIsValidate: validation);
      return validation;
    }

    if (value.length < state.loginIdMinLength) {
      final validation =
          Validation.create(isValid: false, message: minMaxLenghtMessage);
      state = state.copyWith(loginIdIsValidate: validation);
      return validation;
    }

    final validation =
        Validation.create(isValid: true, message: defaultMessage);

    state = state.copyWith(loginIdIsValidate: validation);
    return validation;
  }
}

// --------------------------------------------------
//
//  typedef Provider
//
// --------------------------------------------------
typedef LoginIdFieldStateProvider
    = StateNotifierProvider<LoginIdFieldStateNotifier, LoginIdFieldState>;

// --------------------------------------------------
//
//  StateNotifierProviderCreateor
//
// --------------------------------------------------
Function loginIdFieldStateNotifierProviderCreator = () {
  return StateNotifierProvider<LoginIdFieldStateNotifier, LoginIdFieldState>(
      (ref) => LoginIdFieldStateNotifier());
};
