import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/usecace/user_update_usecase.dart';

import '../../domain/rtc_channel_state.dart';
import '../../infrastructure/rtc_channel_leave_provider.dart';

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
        return () async {
          final rtcLeaveChannel = ref.read(rtcLeaveChannelProvider);

          // チャンネル離脱
          rtcLeaveChannel();

          // DBのUser情報更新
          final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);
          await userUpdateUsecase<FieldValue>(
            leavedAt: FieldValue.serverTimestamp(),
            isOnLongPressing: false,
            pointerPosition: const Offset(0, 0),
          );

          // チャンネル離脱したことをアプリ内の状態として保持
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
