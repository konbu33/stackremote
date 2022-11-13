import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../usecase/channel_join_usecase.dart';
import 'channel_name_field_state.dart';

part 'channel_join_submit_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class ChannelJoinSubmitState with _$ChannelJoinSubmitState {
  const factory ChannelJoinSubmitState._({
    required String channelJoinSubmitWidgetName,
    required Function onSubmit,
  }) = _ChannelJoinSubmitState;

  factory ChannelJoinSubmitState.create({
    required String channelJoinSubmitWidgetName,
    required Function onSubmit,
  }) =>
      ChannelJoinSubmitState._(
        channelJoinSubmitWidgetName: channelJoinSubmitWidgetName,
        onSubmit: onSubmit,
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class ChannelJoinSubmitStateNotifier
    extends StateNotifier<ChannelJoinSubmitState> {
  ChannelJoinSubmitStateNotifier({
    required String channelJoinSubmitWidgetName,
    required Function onSubmit,
  }) : super(ChannelJoinSubmitState.create(
          channelJoinSubmitWidgetName: channelJoinSubmitWidgetName,
          onSubmit: onSubmit,
        ));
}

// --------------------------------------------------
//
// typedef Provider
//
// --------------------------------------------------
typedef ChannelJoinSubmitStateProvider = StateNotifierProvider<
    ChannelJoinSubmitStateNotifier, ChannelJoinSubmitState>;

// --------------------------------------------------
//
// StateNotifierProviderCreator
//
// --------------------------------------------------
ChannelJoinSubmitStateProvider channelJoinSubmitStateNotifierProviderCreator() {
  return StateNotifierProvider<ChannelJoinSubmitStateNotifier,
      ChannelJoinSubmitState>(
    (ref) {
      Function? onSubmit({required BuildContext context}) {
        final state = ref.watch(ChannelNameFieldStateNotifierProviderList
            .channelNameFieldStateNotifierProvider);

        return state.channelNameIsValidate.isValid == false
            ? null
            : () async {
                final channelJoinUsecase = ref.read(channelJoinUsecaseProvider);
                await channelJoinUsecase();
              };
      }

      return ChannelJoinSubmitStateNotifier(
        channelJoinSubmitWidgetName: "チャンネル参加",
        onSubmit: onSubmit,
      );
    },
  );
}

// --------------------------------------------------
//
// StateNotifierProviderList
//
// --------------------------------------------------
class ChannelJoinSubmitStateProviderList {
  static final channelJoinSubmitStateNotifierProvider =
      channelJoinSubmitStateNotifierProviderCreator();
}
