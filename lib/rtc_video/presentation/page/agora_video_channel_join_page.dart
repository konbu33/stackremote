import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: authentication, common, menuのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../authentication/authentication.dart';
import '../../../common/common.dart';
import '../../../menu/menu.dart';

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

    final channelNameFieldState = ref.watch(
        ChannelNameFieldStateNotifierProviderList
            .channelNameFieldStateNotifierProvider);

    return Scaffold(
      drawer: AgoraVideoChannelJoinPageWidgets.menuWidget(),
      appBar: AppBar(
        title: Text(state.pageTitle),
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
    final Widget widget = Consumer(
      builder: ((context, ref, child) {
        // imporve : state.dartにまとめた方が良いか？ProviderListで定義して利用する方が良いか？
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
    // imporve : state.dartにまとめた方が良いか？ProviderListで定義して利用する方が良いか？
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
    // imporve : state.dartにまとめた方が良いか？ProviderListで定義して利用する方が良いか？
    final channelJoinSubmitStateProvider = ChannelJoinSubmitStateProviderList
        .channelJoinSubmitStateNotifierProvider;

    final Widget widget = ChannelJoinSubmitWidget(
      channelJoinSubmitStateProvider: channelJoinSubmitStateProvider,
    );

    return widget;
  }
}
