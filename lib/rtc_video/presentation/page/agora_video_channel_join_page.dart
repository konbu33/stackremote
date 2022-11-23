import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../../menu/menu.dart';

import '../widget/channel_join_submit_widget.dart';
import '../widget/channel_name_field_widget.dart';

import 'agora_video_channel_join_page_state.dart';

class AgoraVideoChannelJoinPage extends HookConsumerWidget {
  const AgoraVideoChannelJoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelNameFieldState = ref.watch(
        AgoraVideoChannelJoinPageState.channelNameFieldStateNotifierProvider);

    return Scaffold(
      drawer: AgoraVideoChannelJoinPageWidgets.menuWidget(),
      appBar: AppBar(
        title: const Text(AgoraVideoChannelJoinPageState.pageTitle),
        actions: [
          AgoraVideoChannelJoinPageWidgets.signOutIconButton(),
        ],
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: [channelNameFieldState.focusNode],
        children: [
          Form(
            key: GlobalKey<FormState>(),
            child: Column(
              children: [
                AgoraVideoChannelJoinPageWidgets.messageWidget(),
                const SizedBox(height: 40),
                AgoraVideoChannelJoinPageWidgets.channelNameFieldWidget(),
                const SizedBox(height: 40),
                AgoraVideoChannelJoinPageWidgets.channelJoinSubmitWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AgoraVideoChannelJoinPageWidgets {
  // menu
  static Widget menuWidget() {
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        return const MenuWidget();
      },
    );

    return widget;
  }

  // signOutIconButton
  static Widget signOutIconButton() {
    //
    final Widget widget = Consumer(
      builder: ((context, ref, child) {
        return AppbarAcitonIconWidget(
          appbarActionIconStateProvider: ref
              .watch(AgoraVideoChannelJoinPageState.signOutIconStateProvider),
        );
      }),
    );

    return widget;
  }

  // Message Widget
  static Widget messageWidget() {
    //
    final Widget widget = Consumer(builder: (context, ref, child) {
      const style = TextStyle(color: Colors.red);
      return Text(
        ref.watch(AgoraVideoChannelJoinPageState.messageProvider),
        style: style,
      );
    });

    return widget;
  }

  // channelNameFieldWidget
  static Widget channelNameFieldWidget() {
    //
    final Widget widget = ChannelNameFieldWidget(
      channelNameFieldStateProvider:
          AgoraVideoChannelJoinPageState.channelNameFieldStateNotifierProvider,
    );

    return widget;
  }

  // Login Submit Widget
  static Widget channelJoinSubmitWidget() {
    final Widget widget = ChannelJoinSubmitWidget(
      channelJoinSubmitStateProvider:
          AgoraVideoChannelJoinPageState.channelJoinSubmitStateNotifierProvider,
    );

    return widget;
  }
}
