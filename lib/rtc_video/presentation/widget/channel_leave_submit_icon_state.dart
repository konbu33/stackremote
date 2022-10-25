import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../authentication/authentication.dart';
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

          rtcLeaveChannel();

          final rtcChannelState = ref.watch(RtcChannelStateNotifierProviderList
              .rtcChannelStateNotifierProvider);

          final firebaseAuthUser =
              ref.watch(firebaseAuthUserStateNotifierProvider);

          final data = {
            "leavedAt": FieldValue.serverTimestamp(),
          };

          await FirebaseFirestore.instance
              .collection('channels')
              .doc(rtcChannelState.channelName)
              .collection('users')
              .doc(firebaseAuthUser.email)
              .update(data);

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
