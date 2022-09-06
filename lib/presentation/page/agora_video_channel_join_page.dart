import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/domain/user.dart';

import '../widget/appbar_action_icon_widget.dart';
import '../widget/background_image_widget.dart';
import '../widget/base_layout_widget.dart';

import '../widget/channel_join_submit_state.dart';
import '../widget/channel_join_submit_widget.dart';
import '../widget/channel_name_field_state.dart';
import '../widget/channel_name_field_widget.dart';
import 'agora_video_channel_join_page_state.dart';

class AgoraVideoChannelJoinPage extends HookConsumerWidget {
  const AgoraVideoChannelJoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(agoraVideoChannelJoinPageStateNotifierProvider);

    return BackgroundImageWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(state.pageTitle),
          actions: [
            AgoraVideoChannelJoinPageWidgets.signOutIconButton(),
          ],
        ),
        body: BaseLayoutWidget(
          children: [
            Form(
              key: GlobalKey<FormState>(),
              child: Column(
                children: [
                  AgoraVideoChannelJoinPageWidgets.channelNameFieldWidget(),
                  const SizedBox(height: 40),
                  AgoraVideoChannelJoinPageWidgets.channelJoinSubmitWidget(),
                  () {
                    final user = ref.watch(userStateNotifierProvider);
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        "idToken: ${user}",
                        maxLines: 10,
                      ),
                    );
                  }(),
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
  static Widget signOutIconButton() {
    final Widget widget = Consumer(
      builder: ((context, ref, child) {
        final state = ref.watch(agoraVideoChannelJoinPageStateNotifierProvider);

        return AppbarAcitonIconWidget(
          appbarActionIconStateProvider: state.signOutIconStateProvider,
        );
      }),
    );

    return widget;
  }

  // Login Id Field Widget
  static Widget channelNameFieldWidget() {
    final channelNameFieldStateProvider =
        ChannelNameFieldStateNotifierProviderList
            .channelNameFieldStateNotifierProvider;

    final Widget widget = ChannelNameFieldWidget(
      channelNameFieldStateProvider: channelNameFieldStateProvider,
    );

    return widget;
  }

  // Login Submit Widget
  static Widget channelJoinSubmitWidget() {
    final channelJoinSubmitStateProvider = ChannelJoinSubmitStateProviderList
        .channelJoinSubmitStateNotifierProvider;

    final Widget widget = ChannelJoinSubmitWidget(
      channelJoinSubmitStateProvider: channelJoinSubmitStateProvider,
    );

    return widget;
  }
}
