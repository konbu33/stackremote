import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/presentation/widget/agora_video_token_create_widget.dart';
import '../../pointer/pointer.dart';
import '../widget/agora_video_join_channel_widget.dart';
import '../widget/agora_video_leave_channel_widget.dart';
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
    final notifier = ref.watch(agoraVideoPageStateNotifierProvider.notifier);

    return BackgroundImageWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agora Video'),
        ),
        body: PointerOverlayWidget(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AgoraVideoPageWidgets.buildJoinChannelWidget(state, notifier),
                  AgoraVideoPageWidgets.buildLeaveChannelWidget(state),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AgoraVideoPageWidgets.buildTokenCreateWidget(state, notifier),
                ],
              ),
              Text("${state}"),
              Flexible(
                child: Stack(
                  children: [
                    Center(
                      child: state.viewSwitch
                          ? AgoraVideoPageWidgets.buildRemotePreviewWidget(
                              state)
                          : AgoraVideoPageWidgets.buildLocalPreviewWidget(
                              state),
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
                                ? AgoraVideoPageWidgets.buildLocalPreviewWidget(
                                    state)
                                : AgoraVideoPageWidgets
                                    .buildRemotePreviewWidget(state),
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
  // Join Channel Widget
  static Widget buildJoinChannelWidget(
    AgoraVideoPageState state,
    AgoraVideoPageStateNotifier notifier,
  ) {
    final Widget widget = AgoraVideoJoinChannelWidget(
      state: state,
      notifier: notifier,
    );
    return widget;
  }

  // Leave Channel Widget
  static Widget buildLeaveChannelWidget(AgoraVideoPageState state) {
    final Widget widget = AgoraVideoLeaveChannelWidget(state: state);
    return widget;
  }

  // Token Create Widget
  static Widget buildTokenCreateWidget(
      AgoraVideoPageState state, AgoraVideoPageStateNotifier notifier) {
    final Widget widget = AgoraVideoTokenCreateWidget(
      state: state,
      notifier: notifier,
    );
    return widget;
  }

  // Local Preview Widget
  static Widget buildLocalPreviewWidget(AgoraVideoPageState state) {
    final Widget widget = AgoraVideoLocalPreviewWidget(state: state);
    return widget;
  }

  // Remote Preview Widget
  static Widget buildRemotePreviewWidget(AgoraVideoPageState state) {
    final Widget widget = AgoraVideoRemotePreviewWidget(state: state);
    return widget;
  }
}
