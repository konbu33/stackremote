import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../widget/progress_state_channel_leave.dart';

class RtcVideoPageState {
  // --------------------------------------------------
  //
  //   viewSwitchProvider
  //
  // --------------------------------------------------
  static final viewSwitchProvider = StateProvider.autoDispose((ref) => false);

  static final positionProvider = StateProvider((ref) => const Offset(0, 0));
  // --------------------------------------------------
  //
  //  channelLeaveProgressStateNotifierProviderOfProvider
  //
  // --------------------------------------------------
  static final channelLeaveProgressStateNotifierProviderOfProvider =
      Provider((ref) {
    final function = ref.watch(progressStateChannelLeaveProvider);

    return progressStateNotifierProviderCreator(function: function);
  });

  // --------------------------------------------------
  //
  //  channelLeaveSubmitIconStateProvider
  //
  // --------------------------------------------------
  static final channelLeaveSubmitIconStateNotifierProvider = Provider(
    (ref) {
      void Function() buidChannelLeaveOnSubmit() {
        return () async {
          final channelLeaveProgressStateNotifierProvider =
              ref.read(channelLeaveProgressStateNotifierProviderOfProvider);

          ref
              .read(channelLeaveProgressStateNotifierProvider.notifier)
              .updateProgress();
        };
      }

      final appbarActionIconState = AppbarActionIconState.create(
        onSubmitWidgetName: "チャンネル離脱",
        icon: const Icon(Icons.exit_to_app),
        onSubmit: buidChannelLeaveOnSubmit,
      );

      final appbarActionIconStateNotifierProvider =
          appbarActionIconStateNotifierProviderCreator(
        appbarActionIconState: appbarActionIconState,
      );

      return appbarActionIconStateNotifierProvider;
    },
  );
}
