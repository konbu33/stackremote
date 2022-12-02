import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/validation.dart';

part 'loginid_field_state.freezed.dart';

// --------------------------------------------------
//
// LoginIdFieldState
//
// --------------------------------------------------
@freezed
class LoginIdFieldState with _$LoginIdFieldState {
  const factory LoginIdFieldState._({
    // ignore: unused_element
    @Default("メールアドレス") String loginIdFieldName,
    required Widget loginIdField,
    required GlobalKey<FormFieldState> loginIdFieldKey,
    required FocusNode focusNode,
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
      focusNode: FocusNode(),
      loginIdFieldController: TextEditingController(),
      loginIdIcon: const Icon(Icons.mail),
      loginIdIsValidate: Validation.create(),
    );
  }
}

// --------------------------------------------------
//
// LoginIdFieldStateNotifier
//
// --------------------------------------------------
class LoginIdFieldStateNotifier extends AutoDisposeNotifier<LoginIdFieldState> {
  @override
  LoginIdFieldState build() {
    final loginIdFieldState = LoginIdFieldState.create();
    return loginIdFieldState;
  }

  void setUserEmail(String value) {
    state = state.copyWith(
        loginIdFieldController: TextEditingController(text: value));
  }

  Validation loginIdCustomValidator(String value) {
    const defaultMessage = "";
    const emptyMessage = "";

    final minMaxLenghtMessage =
        "${state.loginIdMinLength}文字以上、${state.loginIdMaxLength}文字以下で入力して下さい。";

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
//  loginIdFieldStateNotifierProviderCreator
//
// --------------------------------------------------
typedef LoginIdFieldStateProvider
    = AutoDisposeNotifierProvider<LoginIdFieldStateNotifier, LoginIdFieldState>;

LoginIdFieldStateProvider loginIdFieldStateNotifierProviderCreator() {
  return NotifierProvider.autoDispose<LoginIdFieldStateNotifier,
      LoginIdFieldState>(() => LoginIdFieldStateNotifier());
}
