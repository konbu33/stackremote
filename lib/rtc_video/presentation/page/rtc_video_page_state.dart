import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/rtc_video/usecase/switch_camera.dart';

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

  static final attentionMessageStateProvider =
      StateProvider.autoDispose((ref) => "");

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
  //  switchCameraSubmitIconStateNotifierProvider
  //
  // --------------------------------------------------
  static final switchCameraSubmitIconStateNotifierProvider = Provider(
    (ref) {
      AppbarActionIconOnSubmitFunction buidSwitchCameraOnSubmit() {
        return ({required BuildContext context}) => () async {
              final switchCameraUsecase = ref.read(switchCameraUsecaseProvider);
              await switchCameraUsecase();
            };
      }

      final appbarActionIconState = AppbarActionIconState.create(
        onSubmitWidgetName: "カメラ切替",
        icon: const Icon(Icons.cameraswitch),
        onSubmit: buidSwitchCameraOnSubmit(),
      );

      final appbarActionIconStateNotifierProvider =
          appbarActionIconStateNotifierProviderCreator(
        appbarActionIconState: appbarActionIconState,
      );

      return appbarActionIconStateNotifierProvider;
    },
  );

  // --------------------------------------------------
  //
  //  channelLeaveSubmitIconStateProvider
  //
  // --------------------------------------------------
  static final channelLeaveSubmitIconStateNotifierProvider = Provider(
    (ref) {
      AppbarActionIconOnSubmitFunction buidChannelLeaveOnSubmit() {
        return ({required BuildContext context}) => () async {
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
        onSubmit: buidChannelLeaveOnSubmit(),
      );

      final appbarActionIconStateNotifierProvider =
          appbarActionIconStateNotifierProviderCreator(
        appbarActionIconState: appbarActionIconState,
      );

      return appbarActionIconStateNotifierProvider;
    },
  );
}
