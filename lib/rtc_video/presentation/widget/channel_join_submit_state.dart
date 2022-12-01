import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../page/agora_video_channel_join_page_state.dart';

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
class ChannelJoinSubmitStateNotifier extends Notifier<ChannelJoinSubmitState> {
  @override
  ChannelJoinSubmitState build() {
    void Function()? onSubmit() {
      final state = ref.watch(
          AgoraVideoChannelJoinPageState.channelNameFieldStateNotifierProvider);

      return state.channelNameIsValidate.isValid == false
          ? null
          : () {
              // channel参加
              ref
                  .read(AgoraVideoChannelJoinPageState
                      .channelJoinProgressStateProvider.notifier)
                  .channelJoin();
            };
    }

    return ChannelJoinSubmitState.create(
      channelJoinSubmitWidgetName: "チャンネル参加",
      onSubmit: onSubmit,
    );
  }
}

// --------------------------------------------------
//
// typedef Provider
//
// --------------------------------------------------
typedef ChannelJoinSubmitStateNotifierProvider
    = NotifierProvider<ChannelJoinSubmitStateNotifier, ChannelJoinSubmitState>;

// --------------------------------------------------
//
// StateNotifierProviderCreator
//
// --------------------------------------------------
ChannelJoinSubmitStateNotifierProvider
    channelJoinSubmitStateNotifierProviderCreator() {
  return NotifierProvider<ChannelJoinSubmitStateNotifier,
      ChannelJoinSubmitState>(() => ChannelJoinSubmitStateNotifier());
}
