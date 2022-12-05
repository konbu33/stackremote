import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: pointerのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../channel/channel.dart';
import '../../../common/common.dart';
import '../../../pointer/pointer.dart';

import '../../../user/user.dart';
import '../../domain/rtc_channel_state.dart';

import '../widget/rtc_video_local_preview_widget.dart';
import '../widget/rtc_video_remote_preview_widget.dart';

import 'rtc_video_page_state.dart';

class RtcVideoPage extends HookConsumerWidget {
  const RtcVideoPage({Key? key}) : super(key: key);

// ---------------------------------------------------
//
//
//  build
//
//
// ---------------------------------------------------

  // Build UI
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelName = ref.watch(channelNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: Tooltip(
          message: "チャンネル名",
          child: Text(channelName),
        ),
        actions: [
          RtcVideoPageWidgets.buildLeaveChannelIconWidget(),
        ],
      ),
      body: PointerOverlayWidget(
        child: Flexible(
          child: Stack(
            children: [
              Center(
                child: ref.watch(RtcVideoPageState.viewSwitchProvider)
                    ? RtcVideoPageWidgets.buildRemotePreviewWidget()
                    : RtcVideoPageWidgets.buildLocalPreviewWidget(),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(RtcVideoPageState.viewSwitchProvider.notifier)
                          .update((state) => !state);
                    },
                    child: Center(
                      child: ref.watch(RtcVideoPageState.viewSwitchProvider)
                          ? RtcVideoPageWidgets.buildLocalPreviewWidget()
                          : RtcVideoPageWidgets.buildRemotePreviewWidget(),
                    ),
                  ),
                ),
              ),
              RtcVideoPageWidgets.buildDisplayState(),
              RtcVideoPageWidgets.channelLeaveProgressWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------
//
//
// PageWidgets
//
//
// ---------------------------------------------------

class RtcVideoPageWidgets {
  // buildLeaveChannelIconWidget
  static Widget buildLeaveChannelIconWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      return AppbarAcitonIconWidget(
        appbarActionIconStateNotifierProvider: ref.watch(
            RtcVideoPageState.channelLeaveSubmitIconStateNotifierProvider),
      );
    }));

    return widget;
  }

  // Local Preview Widget
  static Widget buildLocalPreviewWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      return const RtcVideoLocalPreviewWidget();
    }));
    return widget;
  }

  // Remote Preview Widget
  static Widget buildRemotePreviewWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      final channelName = ref.watch(channelNameProvider);
      final remoteUid = ref.watch(RtcChannelState.remoteUidProvider);

      return RtcVideoRemotePreviewWidget(
        channelName: channelName,
        remoteUid: remoteUid,
      );
    }));

    return widget;
  }

  // Display State Widget
  static Widget buildDisplayState() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      final channelState = ref.watch(channelStateNotifierProvider);
      logger.d("videochannel: $channelState");

      final userState = ref.watch(userStateNotifierProvider);
      logger.d("videouser: $userState");

      final usersState = ref.watch(usersStateNotifierProvider);
      logger.d("videousers: $usersState");

      if (usersState.isGetDataError) {
        const snackBar = SnackBar(content: Text("ユーザ情報の取得に失敗しました。"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      return const SizedBox();
    }));

    return widget;
  }

  static Widget channelLeaveProgressWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final channelLeaveProgressStateNotifierProvider = ref.watch(
          RtcVideoPageState
              .channelLeaveProgressStateNotifierProviderOfProvider);

      return ProgressWidget(
        progressStateNotifierProvider:
            channelLeaveProgressStateNotifierProvider,
      );
    });

    return widget;
  }
}
