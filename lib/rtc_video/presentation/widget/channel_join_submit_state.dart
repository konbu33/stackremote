import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/rtc_channel_state.dart';
import '../../infrastructure/rtc_channel_join_provider.dart';
import '../../infrastructure/rtc_token_create_provider.dart';

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
                final notifier = ref.read(RtcChannelStateNotifierProviderList
                    .rtcChannelStateNotifierProvider.notifier);

                notifier
                    .updateChannelName(state.channelNameFieldController.text);

                final rtcCreateToken = ref.watch(rtcTokenCreateOnCallProvider);

                try {
                  await rtcCreateToken();
                } on FirebaseFunctionsException catch (error) {
                  final snackBar = SnackBar(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 50),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.cyan,
                    duration: const Duration(seconds: 5),
                    content: Text(
                      "ERROR : ${error.message}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

                final rtcJoinChannel = ref.watch(rtcJoinChannelProvider);
                await rtcJoinChannel();

                notifier.changeJoined(true);
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
