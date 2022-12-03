import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../validation/validation.dart';

part 'name_field_state.freezed.dart';

// --------------------------------------------------
//
// NameFieldState
//
// --------------------------------------------------
@freezed
class NameFieldState with _$NameFieldState {
  const factory NameFieldState._({
    required String name,
    required GlobalKey<FormFieldState> formFieldKey,
    required FocusNode focusNode,
    required TextEditingController textEditingController,
    required Icon icon,
    required Validation isValidate,
    required Validation Function(String) validator,
    required int minLength,
    required int maxLength,
  }) = _NameFieldState;

  factory NameFieldState.create({
    required String name,
    required Validation Function(String) validator,
  }) {
    return NameFieldState._(
      name: name,
      formFieldKey: GlobalKey<FormFieldState>(),
      focusNode: FocusNode(),
      textEditingController: TextEditingController(),
      icon: const Icon(Icons.mail),
      isValidate: Validation.create(),
      validator: validator,
      minLength: 8,
      maxLength: 20,
    );
  }
}

// --------------------------------------------------
//
// NameFieldStateNotifier
//
// --------------------------------------------------
class NameFieldStateNotifier extends AutoDisposeNotifier<NameFieldState> {
  NameFieldStateNotifier({
    required this.name,
    required this.validator,
  });

  final String name;
  final Validation Function(String) validator;

  @override
  NameFieldState build() {
    final nameFieldState = NameFieldState.create(
      name: name,
      validator: validator,
    );

    return nameFieldState;
  }

  void setUserEmail(String value) {
    state = state.copyWith(
        textEditingController: TextEditingController(text: value));
  }

  void updateIsValidate(Validation validation) {
    state = state.copyWith(isValidate: validation);
  }

  // Validation customValidator(String value) {
  //   const defaultMessage = "";
  //   const emptyMessage = "";

  //   final minMaxLenghtMessage =
  //       "${state.minLength}文字以上、${state.maxLength}文字以下で入力して下さい。";

  //   if (value.isEmpty) {
  //     final validation =
  //         Validation.create(isValid: false, message: emptyMessage);
  //     state = state.copyWith(isValidate: validation);
  //     return validation;
  //   }

  //   if (value.length < state.minLength) {
  //     final validation =
  //         Validation.create(isValid: false, message: minMaxLenghtMessage);
  //     state = state.copyWith(isValidate: validation);
  //     return validation;
  //   }

  //   final validation =
  //       Validation.create(isValid: true, message: defaultMessage);

  //   state = state.copyWith(isValidate: validation);
  //   return validation;
  // }
}

// --------------------------------------------------
//
//  nameFieldStateNotifierProviderCreator
//
// --------------------------------------------------
typedef NameFieldStateNotifierProvider
    = AutoDisposeNotifierProvider<NameFieldStateNotifier, NameFieldState>;

NameFieldStateNotifierProvider nameFieldStateNotifierProviderCreator({
  required String name,
  required Validation Function(String) validator,
}) {
  return NotifierProvider.autoDispose<NameFieldStateNotifier, NameFieldState>(
      () => NameFieldStateNotifier(
            name: name,
            validator: validator,
          ));
}
