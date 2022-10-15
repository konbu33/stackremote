// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/menu/menu_routing_layer.dart';

// import '../../../authentication/domain/firebase_auth_user.dart';
import '../../../authentication/presentation/widget/appbar_action_icon_widget.dart';
// import '../../../authentication/presentation/widget/scaffold_body_base_layout_widget.dart';

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

    return Scaffold(
      drawer: AgoraVideoChannelJoinPageWidgets.menuWidget(),
      appBar: AppBar(
        title: Text(state.pageTitle),
        actions: [
          AgoraVideoChannelJoinPageWidgets.signOutIconButton(),
        ],
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        children: [
          Form(
            key: GlobalKey<FormState>(),
            child: Column(
              children: [
                AgoraVideoChannelJoinPageWidgets.channelNameFieldWidget(),
                const SizedBox(height: 40),
                AgoraVideoChannelJoinPageWidgets.channelJoinSubmitWidget(),
                // const Divider(),
                // () {
                //   // final user = ref.watch(userStateNotifierProvider);
                //   final user = ref.watch(firebaseAuthUserStateNotifierProvider);
                //   return SingleChildScrollView(
                //     scrollDirection: Axis.vertical,
                //     child: Text(
                //       "firebaseAuthUser: $user",
                //       maxLines: 10,
                //     ),
                //   );
                // }(),
                // const Divider(),
                // () {
                //   final user = FirebaseAuth.instance.currentUser;
                //   return SingleChildScrollView(
                //     scrollDirection: Axis.vertical,
                //     child: Text(
                //       "currentUser: $user",
                //       maxLines: 10,
                //     ),
                //   );
                // }(),
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
        // return const MenuRoutingLayer();
      },
    );

    return widget;
  }

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
