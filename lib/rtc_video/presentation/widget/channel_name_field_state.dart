import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: authenticationのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../authentication/authentication.dart';

part 'channel_name_field_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class ChannelNameFieldState with _$ChannelNameFieldState {
  const factory ChannelNameFieldState._({
    required String channelNameFieldName,
    required Widget channelNameField,
    required GlobalKey<FormFieldState> channelNameFieldKey,
    required FocusNode focusNode,
    required TextEditingController channelNameFieldController,
    required Icon channelNameIcon,
    required Validation channelNameIsValidate,
    // ignore: unused_element
    @Default(8) int channelNameMinLength,
    // ignore: unused_element
    @Default(20) int channelNameMaxLength,
  }) = _ChannelNameFieldState;

  factory ChannelNameFieldState.create() {
    return ChannelNameFieldState._(
      channelNameFieldName: "チャンネル名",
      channelNameField: const Placeholder(),
      channelNameFieldKey: GlobalKey<FormFieldState>(),
      focusNode: FocusNode(),
      channelNameFieldController: TextEditingController(),
      channelNameIcon: const Icon(Icons.room),
      channelNameIsValidate: Validation.create(),
    );
  }
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class ChannelNameFieldStateNotifier
    extends StateNotifier<ChannelNameFieldState> {
  ChannelNameFieldStateNotifier() : super(ChannelNameFieldState.create());

  void initial() {
    state = ChannelNameFieldState.create();
  }

  void setFieldText(String value) {
    state = state.copyWith(
        channelNameFieldController: TextEditingController(text: value));
  }

  Validation channelNameCustomValidator(String value) {
    const defaultMessage = "";
    const emptyMessage = "";

    // final minMaxLenghtMessage =
    //     "Min lenght: ${state.channelNameMinLength}, Max length : ${state.channelNameMaxLength}.";

    final minMaxLenghtMessage =
        "${state.channelNameMinLength}文字以上、${state.channelNameMaxLength}文字以下で入力して下さい。";

    if (value.isEmpty) {
      final validation =
          Validation.create(isValid: false, message: emptyMessage);
      state = state.copyWith(channelNameIsValidate: validation);
      return validation;
    }

    if (value.length < state.channelNameMinLength) {
      final validation =
          Validation.create(isValid: false, message: minMaxLenghtMessage);
      state = state.copyWith(channelNameIsValidate: validation);
      return validation;
    }

    final validation =
        Validation.create(isValid: true, message: defaultMessage);

    state = state.copyWith(channelNameIsValidate: validation);
    return validation;
  }
}

// --------------------------------------------------
//
//  typedef Provider
//
// --------------------------------------------------
typedef ChannelNameFieldStateProvider = StateNotifierProvider<
    ChannelNameFieldStateNotifier, ChannelNameFieldState>;

// --------------------------------------------------
//
//  StateNotifierProviderCreateor
//
// --------------------------------------------------
ChannelNameFieldStateProvider channelNameFieldStateNotifierProviderCreator() {
  return StateNotifierProvider<ChannelNameFieldStateNotifier,
      ChannelNameFieldState>(
    (ref) {
      return ChannelNameFieldStateNotifier();
    },
  );
}

// --------------------------------------------------
//
//  StateNotifierProviderList
//
// --------------------------------------------------
class ChannelNameFieldStateNotifierProviderList {
  static final channelNameFieldStateNotifierProvider =
      channelNameFieldStateNotifierProviderCreator();
}
