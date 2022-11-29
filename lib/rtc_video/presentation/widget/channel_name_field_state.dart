import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: authenticationのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../authentication/authentication.dart';

part 'channel_name_field_state.freezed.dart';

// --------------------------------------------------
//
// ChannelNameFieldState
//
// --------------------------------------------------
@freezed
class ChannelNameFieldState with _$ChannelNameFieldState {
  const factory ChannelNameFieldState._({
    required String channelNameFieldName,
    required GlobalKey<FormFieldState> channelNameFieldKey,
    required FocusNode focusNode,
    required TextEditingController channelNameFieldController,
    required Validation channelNameIsValidate,
    required Icon channelNameIcon,
    required int channelNameMinLength,
    required int channelNameMaxLength,
  }) = _ChannelNameFieldState;

  factory ChannelNameFieldState.create() => ChannelNameFieldState._(
        channelNameFieldName: "チャンネル名",
        channelNameFieldKey: GlobalKey<FormFieldState>(),
        focusNode: FocusNode(),
        channelNameFieldController: TextEditingController(),
        channelNameIsValidate: Validation.create(),
        channelNameIcon: const Icon(Icons.room),
        channelNameMinLength: 8,
        channelNameMaxLength: 20,
      );
}

// --------------------------------------------------
//
// ChannelNameFieldStateNotifier
//
// --------------------------------------------------
class ChannelNameFieldStateNotifier extends Notifier<ChannelNameFieldState> {
  @override
  ChannelNameFieldState build() {
    return ChannelNameFieldState.create();
  }

  void channelNameCustomValidator(String value) {
    Validation validation;

    if (value.length >= state.channelNameMinLength &&
        value.length <= state.channelNameMaxLength) {
      const defaultMessage = "";
      validation = Validation.create(isValid: true, message: defaultMessage);
      state = state.copyWith(channelNameIsValidate: validation);
      return;
    }

    final minMaxLenghtMessage =
        "${state.channelNameMinLength}文字以上、${state.channelNameMaxLength}文字以下で入力して下さい。";
    validation =
        Validation.create(isValid: false, message: minMaxLenghtMessage);
    state = state.copyWith(channelNameIsValidate: validation);
    return;
  }
}

// --------------------------------------------------
//
// channelNameFieldStateNotifierProviderCreator
//
// --------------------------------------------------
typedef ChannelNameFieldStateNotifierProvider
    = NotifierProvider<ChannelNameFieldStateNotifier, ChannelNameFieldState>;

ChannelNameFieldStateNotifierProvider
    channelNameFieldStateNotifierProviderCreator() {
  return NotifierProvider<ChannelNameFieldStateNotifier, ChannelNameFieldState>(
      () => ChannelNameFieldStateNotifier());
}
