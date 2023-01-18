import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/user.dart';

import '../../../common/common.dart';
import '../../../menu/menu.dart';

import 'rtc_video_channel_join_page_state.dart';

class RtcVideoChannelJoinPage extends ConsumerWidget {
  const RtcVideoChannelJoinPage({super.key});

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
          RtcVideoChannelJoinPageWidgets.signOutIconButtonWidget(),
        ],
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: [channelNameFieldState.focusNode],
        children: [
          Form(
            key: GlobalKey<FormState>(),
            child: Column(
              children: [
                Stack(
                  children: [
                    RtcVideoChannelJoinPageWidgets.attentionMessageWidget(),
                    RtcVideoChannelJoinPageWidgets.signOutProgressWidget(),
                    RtcVideoChannelJoinPageWidgets.channelJoinProgressWidget(),
                  ],
                ),
                const SizedBox(height: 40),
                RtcVideoChannelJoinPageWidgets.channelNameFieldWidget(),
                const SizedBox(height: 40),
                RtcVideoChannelJoinPageWidgets.channelJoinOnSubmitWidget(),
                RtcVideoChannelJoinPageWidgets.updateUserStateWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RtcVideoChannelJoinPageWidgets {
  // menuWidget
  static Widget menuWidget() {
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        return const MenuWidget();
      },
    );

    return widget;
  }

  // signOutIconButtonWidget
  static Widget signOutIconButtonWidget() {
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

  // attentionMessageWidget
  static Widget attentionMessageWidget() {
    const textStyle = TextStyle(color: Colors.red);
    final Widget widget = DescriptionMessageWidget(
      descriptionMessageStateProvider:
          RtcVideoChannelJoinPageState.attentionMessageStateProvider,
      textStyle: textStyle,
    );

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

  // channelJoinOnSubmitWidget
  static Widget channelJoinOnSubmitWidget() {
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

  // channelJoinProgressWidget
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

  // signOutProgressWidget
  static Widget signOutProgressWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final signOutProgressStateNotifierProvider = ref.watch(
          RtcVideoChannelJoinPageState
              .signOutProgressStateNotifierProviderOfProvider);

      return ProgressWidget(
        progressStateNotifierProvider: signOutProgressStateNotifierProvider,
      );
    });

    return widget;
  }

  // updateUserStateWidget
  static Widget updateUserStateWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      // localのuserState更新時に、リモートDB上へも反映するためのプロバイダ
      ref.watch(reflectUserNickNameProvider);

      return const SizedBox();
    }));

    return widget;
  }
}
