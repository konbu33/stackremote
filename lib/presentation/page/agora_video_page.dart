import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/presentation/widget/channel_leave_submit_icon_state.dart';
import 'package:stackremote/presentation/widget/channel_leave_submit_icon_widget.dart';
import 'package:stackremote/usecase/rtc_channel_state.dart';
import '../../pointer/pointer.dart';
import '../widget/agora_video_local_preview_widget.dart';
import '../widget/agora_video_remote_preview_widget.dart';
import '../widget/background_image_widget.dart';
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
    final rtcChannelState = ref.watch(
        RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);
    final notifier = ref.watch(agoraVideoPageStateNotifierProvider.notifier);

    return BackgroundImageWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agora Video'),
          actions: [
            AgoraVideoPageWidgets.buildLeaveChannelIconWidget(),
          ],
        ),
        body: PointerOverlayWidget(
          child: Column(
            children: [
              Text("${state}"),
              Text("${rtcChannelState}"),
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
                                ? AgoraVideoPageWidgets
                                    .buildLocalPreviewWidget()
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

      return AgoraVideoLocalPreviewWidget(state: state);
    }));
    return widget;
  }

  // Remote Preview Widget
  static Widget buildRemotePreviewWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      final state = ref.watch(
          RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

      return AgoraVideoRemotePreviewWidget(state: state);
    }));

    return widget;
  }
}
