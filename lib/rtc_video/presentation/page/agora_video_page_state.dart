import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/common/common.dart';

import '../widget/channel_join_progress_state.dart';

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
  static final channelLeaveProgressStateProvider =
      channelJoinProgressStateProviderCreator();

  // --------------------------------------------------
  //
  //  channelLeaveSubmitIconStateProvider
  //
  // --------------------------------------------------
  static final channelLeaveSubmitIconStateNotifierProvider = Provider(
    (ref) {
      void Function() buidChannelLeaveOnSubmit() {
        return () async {
          ref.read(channelLeaveProgressStateProvider.notifier).channelLeave();

          // // --------------------------------------------------
          // //
          // // チャンネル離脱
          // //
          // // --------------------------------------------------
          // final channelLeaveUsecase =
          //     await ref.read(channelLeaveUsecaseProvider);
          // await channelLeaveUsecase();

          // // --------------------------------------------------
          // //
          // // DBのユーザ情報をクリア
          // //
          // // --------------------------------------------------
          // final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);
          // await userUpdateUsecase<FieldValue>(
          //   comment: "",
          //   leavedAt: FieldValue.serverTimestamp(),
          //   isOnLongPressing: false,
          //   pointerPosition: const Offset(0, 0),
          //   displayPointerPosition: const Offset(0, 0),
          // );
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
