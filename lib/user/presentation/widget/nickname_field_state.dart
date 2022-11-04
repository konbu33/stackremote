import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: authenticationのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../authentication/authentication.dart';

part 'nickname_field_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class NickNameFieldState with _$NickNameFieldState {
  const factory NickNameFieldState._({
    required String nickNameFieldName,
    required Widget nickNameField,
    required GlobalKey<FormFieldState> nickNameFieldKey,
    required FocusNode focusNode,
    required TextEditingController nickNameFieldController,
    required Icon nickNameIcon,
    required Validation nickNameIsValidate,
    // ignore: unused_element
    @Default(0) int nickNameMinLength,
    // ignore: unused_element
    @Default(20) int nickNameMaxLength,
  }) = _NickNameFieldState;

  factory NickNameFieldState.create() {
    return NickNameFieldState._(
      nickNameFieldName: "ニックネーム",
      nickNameField: const Placeholder(),
      nickNameFieldKey: GlobalKey<FormFieldState>(),
      focusNode: FocusNode(),
      nickNameFieldController: TextEditingController(),
      nickNameIcon: const Icon(Icons.person),
      nickNameIsValidate: Validation.create(),
    );
  }
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class NickNameFieldStateNotifier extends StateNotifier<NickNameFieldState> {
  NickNameFieldStateNotifier() : super(NickNameFieldState.create());

  void initial() {
    state = NickNameFieldState.create();
  }

  void setFieldText(String value) {
    state = state.copyWith(
        nickNameFieldController: TextEditingController(text: value));
  }

  Validation nickNameCustomValidator(String value) {
    const defaultMessage = "";
    const emptyMessage = "";

    // final minMaxLenghtMessage =
    //     "Min lenght: ${state.nickNameMinLength}, Max length : ${state.nickNameMaxLength}.";

    final minMaxLenghtMessage =
        "${state.nickNameMinLength}文字以上、${state.nickNameMaxLength}文字以下で入力して下さい。";

    if (value.isEmpty) {
      final validation =
          Validation.create(isValid: false, message: emptyMessage);
      state = state.copyWith(nickNameIsValidate: validation);
      return validation;
    }

    if (value.length < state.nickNameMinLength) {
      final validation =
          Validation.create(isValid: false, message: minMaxLenghtMessage);
      state = state.copyWith(nickNameIsValidate: validation);
      return validation;
    }

    final validation =
        Validation.create(isValid: true, message: defaultMessage);

    state = state.copyWith(nickNameIsValidate: validation);
    return validation;
  }
}

// --------------------------------------------------
//
//  typedef Provider
//
// --------------------------------------------------
typedef NickNameFieldStateNotifierProvider
    = StateNotifierProvider<NickNameFieldStateNotifier, NickNameFieldState>;

// --------------------------------------------------
//
//  StateNotifierProviderCreateor
//
// --------------------------------------------------
NickNameFieldStateNotifierProvider nickNameFieldStateNotifierProviderCreator() {
  return StateNotifierProvider<NickNameFieldStateNotifier, NickNameFieldState>(
    (ref) {
      return NickNameFieldStateNotifier();
    },
  );
}

// --------------------------------------------------
//
//  StateNotifierProviderList
//
// --------------------------------------------------
class NickNameFieldStateNotifierProviderList {
  static final nickNameFieldStateNotifierProvider =
      nickNameFieldStateNotifierProviderCreator();
}
