import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/rtc_video/infrastructure/rtc_channel_leave_provider.dart';
import 'package:stackremote/rtc_video/domain/rtc_channel_state.dart';

part 'channel_leave_submit_icon_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class ChannelLeaveSubmitIconState with _$ChannelLeaveSubmitIconState {
  const factory ChannelLeaveSubmitIconState._({
    required String onSubmitWidgetName,
    required Icon icon,
    required Function onSubmit,
  }) = _ChannelLeaveSubmitIconState;

  factory ChannelLeaveSubmitIconState.create({
    required String onSubmitWidgetName,
    required Icon icon,
    required Function onSubmit,
  }) =>
      ChannelLeaveSubmitIconState._(
        onSubmitWidgetName: onSubmitWidgetName,
        icon: icon,
        onSubmit: onSubmit,
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class ChannelLeaveSubmitIconStateNotifier
    extends StateNotifier<ChannelLeaveSubmitIconState> {
  ChannelLeaveSubmitIconStateNotifier({
    required String onSubmitWidgetName,
    required Icon icon,
    required Function onSubmit,
  }) : super(ChannelLeaveSubmitIconState.create(
          onSubmitWidgetName: onSubmitWidgetName,
          icon: icon,
          onSubmit: onSubmit,
        ));
}

// --------------------------------------------------
//
//  typedef Provider
//
// --------------------------------------------------
typedef ChannelLeaveSubmitIconStateProvider = StateNotifierProvider<
    ChannelLeaveSubmitIconStateNotifier, ChannelLeaveSubmitIconState>;

// --------------------------------------------------
//
//  StateNotifierProviderCreator
//
// --------------------------------------------------
ChannelLeaveSubmitIconStateProvider
    channelLeaveSubmitIconStateProviderCreator() {
  return StateNotifierProvider<ChannelLeaveSubmitIconStateNotifier,
      ChannelLeaveSubmitIconState>(
    (ref) {
      final notifier = ref.read(RtcChannelStateNotifierProviderList
          .rtcChannelStateNotifierProvider.notifier);

      Function? onSubmit({required BuildContext context}) {
        return () {
          final rtcLeaveChannel = ref.read(rtcLeaveChannelProvider);

          rtcLeaveChannel();

          notifier.changeJoined(false);
        };
      }

      return ChannelLeaveSubmitIconStateNotifier(
        onSubmitWidgetName: "チャンネル離脱",
        icon: const Icon(Icons.exit_to_app),
        onSubmit: onSubmit,
      );
    },
  );
}

// --------------------------------------------------
//
//  StateNotifierProviderList
//
// --------------------------------------------------
class ChannelLeaveSubmitIconStateProviderList {
  static final channelLeaveSubmitIconStateProvider =
      channelLeaveSubmitIconStateProviderCreator();
}
