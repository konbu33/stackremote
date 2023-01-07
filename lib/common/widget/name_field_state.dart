import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../validation/validation.dart';
import '../validation/validator.dart';

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
    required Validator validator,
    required int minLength,
    required int maxLength,
  }) = _NameFieldState;

  factory NameFieldState.create({
    required String name,
    required Validator validator,
    required int minLength,
    required int maxLength,
  }) {
    return NameFieldState._(
      name: name,
      formFieldKey: GlobalKey<FormFieldState>(),
      focusNode: FocusNode(),
      textEditingController: TextEditingController(),
      icon: const Icon(Icons.mail),
      isValidate: Validation.create(),
      validator: validator,
      minLength: minLength,
      maxLength: maxLength,
    );
  }
}

// --------------------------------------------------
//
// NameFieldStateNotifier
//
// --------------------------------------------------
class NameFieldStateNotifier extends Notifier<NameFieldState> {
  NameFieldStateNotifier({
    required this.name,
    required this.validator,
    required this.minLength,
    required this.maxLength,
  });

  final String name;
  final Validator validator;
  final int minLength;
  final int maxLength;

  @override
  NameFieldState build() {
    final nameFieldState = NameFieldState.create(
      name: name,
      validator: validator,
      minLength: minLength,
      maxLength: maxLength,
    );

    return nameFieldState;
  }

  void setUserEmail(String value) {
    state = state.copyWith(
        textEditingController: TextEditingController(text: value));
  }

  void checkIsValidate(String value) {
    final validation = state.validator(value);

    state = state.copyWith(isValidate: validation);
  }
}

// --------------------------------------------------
//
//  nameFieldStateNotifierProviderCreator
//
// --------------------------------------------------
typedef NameFieldStateNotifierProvider
    = NotifierProvider<NameFieldStateNotifier, NameFieldState>;

typedef Validator = MinMaxLenghtValidator;

NameFieldStateNotifierProvider nameFieldStateNotifierProviderCreator({
  required String name,
  required Validator validator,
  required int minLength,
  required int maxLength,
}) {
  return NotifierProvider<NameFieldStateNotifier, NameFieldState>(
      () => NameFieldStateNotifier(
            name: name,
            validator: validator,
            minLength: minLength,
            maxLength: maxLength,
          ));
}
