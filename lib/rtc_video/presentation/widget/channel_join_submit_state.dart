import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../page/agora_video_channel_join_page_state.dart';

part 'channel_join_submit_state.freezed.dart';

// --------------------------------------------------
//
// ChannelJoinSubmitState
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
// ChannelJoinSubmitStateNotifier
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
// channelJoinSubmitStateNotifierProviderCreator
//
// --------------------------------------------------
typedef ChannelJoinSubmitStateNotifierProvider
    = NotifierProvider<ChannelJoinSubmitStateNotifier, ChannelJoinSubmitState>;

ChannelJoinSubmitStateNotifierProvider
    channelJoinSubmitStateNotifierProviderCreator() {
  return NotifierProvider<ChannelJoinSubmitStateNotifier,
      ChannelJoinSubmitState>(() => ChannelJoinSubmitStateNotifier());
}
