import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/rtc_video/presentation/widget/channel_leave_progress.dart';

import '../../../common/common.dart';

class AgoraVideoPageState {
  // --------------------------------------------------
  //
  //   viewSwitchProvider
  //
  // --------------------------------------------------
  static final viewSwitchProvider = StateProvider.autoDispose((ref) => false);

  // --------------------------------------------------
  //
  //  channelJoinProgressStateProvider
  //
  // --------------------------------------------------
  static final channelLeaveProgressStateNotifierProviderOfProvider =
      Provider((ref) {
    final function = ref.watch(channelLeaveProgressFunctionProvider);

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
