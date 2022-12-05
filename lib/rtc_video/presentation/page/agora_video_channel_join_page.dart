import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../../menu/menu.dart';

import 'agora_video_channel_join_page_state.dart';

class AgoraVideoChannelJoinPage extends HookConsumerWidget {
  const AgoraVideoChannelJoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelNameFieldStateNotifierProvider = ref.watch(
        AgoraVideoChannelJoinPageState
            .channelNameFieldStateNotifierProviderOfProvider);

    final channelNameFieldState =
        ref.watch(channelNameFieldStateNotifierProvider);

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
          Stack(
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
              AgoraVideoChannelJoinPageWidgets.channelJoinProgressWidget(),
            ],
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
          appbarActionIconStateNotifierProvider: ref
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
        ref.watch(AgoraVideoChannelJoinPageState.attentionMessageStateProvider),
        style: style,
      );
    });

    return widget;
  }

  // channelNameFieldWidget
  static Widget channelNameFieldWidget() {
    //
    final Widget widget = Consumer(builder: (context, ref, child) {
      final channelNameFieldStateNotifierProvider = ref.watch(
          AgoraVideoChannelJoinPageState
              .channelNameFieldStateNotifierProviderOfProvider);

      return NameFieldWidget(
        nameFieldStateNotifierProvider: channelNameFieldStateNotifierProvider,
      );
    });

    return widget;
  }

  // Login Submit Widget
  static Widget channelJoinSubmitWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      return OnSubmitButtonWidget(
        onSubmitButtonStateNotifierProvider: ref.watch(
          AgoraVideoChannelJoinPageState
              .channelJoinOnSubmitButtonStateNotifierProvider,
        ),
      );
    });

    return widget;
  }

  //
  static Widget channelJoinProgressWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final channelJoinProgressStateProvider = ref.watch(
          AgoraVideoChannelJoinPageState
              .channelJoinProgressStateProviderOfProvider);

      return ProgressWidget(
        progressStateNotifierProvider: channelJoinProgressStateProvider,
      );
    });

    return widget;
  }
}
