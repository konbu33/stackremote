import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widget/agora_video_token_create_widget.dart';
import '../widget/appbar_action_icon_widget.dart';
import '../widget/background_image_widget.dart';
import '../widget/base_layout_widget.dart';

import '../widget/loginid_field_widget.dart';
import 'agora_video_channel_join_page_state.dart';
import 'agora_video_page_state.dart';

class AgoraVideoChannelJoinPage extends HookConsumerWidget {
  const AgoraVideoChannelJoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinChannelState =
        ref.watch(agoraVideoChannelJoinPageStateNotifierProvider);

    final state = ref.watch(agoraVideoPageStateNotifierProvider);
    final notifier = ref.watch(agoraVideoPageStateNotifierProvider.notifier);

    return BackgroundImageWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Join Channel"),
          actions: [
            AgoraVideoChannelJoinPageWidgets.signOutIconButton(
                joinChannelState),
          ],
        ),
        body: BaseLayoutWidget(
          children: [
            Form(
              key: GlobalKey<FormState>(),
              child: Column(
                children: [
                  AgoraVideoChannelJoinPageWidgets.loginIdField(
                      joinChannelState),
                  const SizedBox(height: 40),
                  AgoraVideoChannelJoinPageWidgets.loginSubmitWidget(
                      state, notifier),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgoraVideoChannelJoinPageWidgets {
  // signOutIconButton
  static Widget signOutIconButton(AgoraVideoChannelJoinPageState state) {
    final Widget widget = AppbarAcitonIconWidget(
      appbarActionIconStateProvider: state.signOutIconStateProvider,
    );

    return widget;
  }

  // Login Id Field Widget
  static Widget loginIdField(AgoraVideoChannelJoinPageState state) {
    final Widget widget = LoginIdFieldWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
    );
    return widget;
  }

  // Login Submit Widget
  static Widget loginSubmitWidget(
    AgoraVideoPageState state,
    AgoraVideoPageStateNotifier notifier,
  ) {
    final Widget widget = AgoraVideoTokenCreateWidget(
      state: state,
      notifier: notifier,
    );
    return widget;
  }
}
