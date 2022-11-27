import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/rtc_video/usecase/channel_leave.dart';

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
      Function? onSubmit() {
        return () async {
          final channelLeaveUsecase =
              await ref.read(channelLeaveUsecaseProvider);

          // チャンネル離脱
          await channelLeaveUsecase();
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
