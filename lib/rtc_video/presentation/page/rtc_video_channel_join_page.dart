import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../../menu/menu.dart';

import 'rtc_video_channel_join_page_state.dart';

class RtcVideoChannelJoinPage extends HookConsumerWidget {
  const RtcVideoChannelJoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelNameFieldStateNotifierProvider = ref.watch(
        RtcVideoChannelJoinPageState
            .channelNameFieldStateNotifierProviderOfProvider);

    final channelNameFieldState =
        ref.watch(channelNameFieldStateNotifierProvider);

    return Scaffold(
      drawer: RtcVideoChannelJoinPageWidgets.menuWidget(),
      appBar: AppBar(
        title: const Text(RtcVideoChannelJoinPageState.pageTitle),
        actions: [
          RtcVideoChannelJoinPageWidgets.signOutIconButton(),
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
                    RtcVideoChannelJoinPageWidgets.messageWidget(),
                    const SizedBox(height: 40),
                    RtcVideoChannelJoinPageWidgets.channelNameFieldWidget(),
                    const SizedBox(height: 40),
                    RtcVideoChannelJoinPageWidgets.channelJoinSubmitWidget(),
                  ],
                ),
              ),
              RtcVideoChannelJoinPageWidgets.channelJoinProgressWidget(),
            ],
          ),
        ],
      ),
    );
  }
}

class RtcVideoChannelJoinPageWidgets {
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
          appbarActionIconStateNotifierProvider:
              ref.watch(RtcVideoChannelJoinPageState.signOutIconStateProvider),
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
        ref.watch(RtcVideoChannelJoinPageState.attentionMessageStateProvider),
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
          RtcVideoChannelJoinPageState
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
          RtcVideoChannelJoinPageState
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
          RtcVideoChannelJoinPageState
              .channelJoinProgressStateProviderOfProvider);

      return ProgressWidget(
        progressStateNotifierProvider: channelJoinProgressStateProvider,
      );
    });

    return widget;
  }
}
