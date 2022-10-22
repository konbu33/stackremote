import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: pointerのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../pointer/pointer.dart';

import '../../domain/rtc_channel_state.dart';

import '../widget/agora_video_local_preview_widget.dart';
import '../widget/agora_video_remote_preview_widget.dart';
import '../widget/channel_leave_submit_icon_state.dart';
import '../widget/channel_leave_submit_icon_widget.dart';

import 'agora_video_page_state.dart';

class AgoraVideoPage extends HookConsumerWidget {
  const AgoraVideoPage({Key? key}) : super(key: key);

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
    final state = ref.watch(agoraVideoPageStateNotifierProvider);
    final notifier = ref.watch(agoraVideoPageStateNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video'),
        actions: [
          AgoraVideoPageWidgets.buildLeaveChannelIconWidget(),
        ],
      ),
      body: PointerOverlayWidget(
        child: Column(
          children: [
            Flexible(
              child: Stack(
                children: [
                  Center(
                    child: state.viewSwitch
                        ? AgoraVideoPageWidgets.buildRemotePreviewWidget()
                        : AgoraVideoPageWidgets.buildLocalPreviewWidget(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                      child: GestureDetector(
                        onTap: () {
                          notifier.toggleViewSwitch();
                        },
                        child: Center(
                          child: state.viewSwitch
                              ? AgoraVideoPageWidgets.buildLocalPreviewWidget()
                              : AgoraVideoPageWidgets
                                  .buildRemotePreviewWidget(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

class AgoraVideoPageWidgets {
  // Leave Channel Icon Widget
  static Widget buildLeaveChannelIconWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      final channelLeaveSubmitIconStateProvider =
          ChannelLeaveSubmitIconStateProviderList
              .channelLeaveSubmitIconStateProvider;

      return ChannelLeaveSubmitIconWidget(
        channelLeaveSubmitIconStateProvider:
            channelLeaveSubmitIconStateProvider,
      );
    }));
    return widget;
  }

  // Local Preview Widget
  static Widget buildLocalPreviewWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      final state = ref.watch(
          RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

      // return AgoraVideoView(
      //   controller: VideoViewController(
      //     rtcEngine: createAgoraRtcEngine(),
      //     canvas: VideoCanvas(uid: state.localUid),
      //   ),
      // );

      return AgoraVideoLocalPreviewWidget(state: state);
    }));
    return widget;
  }

  // Remote Preview Widget
  static Widget buildRemotePreviewWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      final state = ref.watch(
          RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

      // // if (_remoteUid != null) {
      // return AgoraVideoView(
      //   controller: VideoViewController.remote(
      //     rtcEngine: createAgoraRtcEngine(),
      //     canvas: VideoCanvas(uid: state.remoteUid),
      //     connection: RtcConnection(
      //       channelId: state.channelName,
      //       localUid: state.localUid,
      //     ),
      //   ),
      // );
      // // } else {
      // //   return const Text(
      // //     'Please wait for remote user to join',
      // //     textAlign: TextAlign.center,
      // //   );
      // // }

      return AgoraVideoRemotePreviewWidget(state: state);
    }));

    return widget;
  }
}
