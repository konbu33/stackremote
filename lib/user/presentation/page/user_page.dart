import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/menu/menu.dart';

import '../../../common/common.dart';
import '../../domain/user.dart';
import 'user_page_state.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickNameFieldStateNotifierProvider =
        ref.watch(UserPageState.nickNameFieldStateNotifierProviderOfProvider);

    final nickNameFieldState = ref.watch(nickNameFieldStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: UserPageWidgets.pageTitleWidget(),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref
                .read(menuRoutingCurrentPathProvider.notifier)
                .update((state) => MenuRoutingPath.rtcVideoChannelJoin);
          },
        ),
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: [nickNameFieldState.focusNode],
        children: [
          Form(
            key: GlobalKey<FormState>(),
            child: Column(
              children: [
                UserPageWidgets.currentNickNameWidget(),
                const SizedBox(height: 40),
                UserPageWidgets.attentionMessageWidget(),
                const SizedBox(height: 40),
                UserPageWidgets.userNameFieldWidget(),
                const SizedBox(height: 40),
                UserPageWidgets.userUpdateButtonWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserPageWidgets {
  // pageTitleWidget
  static Widget pageTitleWidget() {
    //
    const Widget widget = Text(UserPageState.pageTitle);
    return widget;
  }

  // currentNickNameWidget
  static Widget currentNickNameWidget() {
    //
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        final userState = ref.watch(userStateNotifierProvider);
        return Text("現在のニックネーム：${userState.nickName}");
      },
    );
    return widget;
  }

// attentionMessageWidget
  static Widget attentionMessageWidget() {
    const textStyle = TextStyle(color: Colors.red);
    final Widget widget = DescriptionMessageWidget(
      descriptionMessageStateProvider:
          UserPageState.attentionMessageStateProvider,
      textStyle: textStyle,
    );

    return widget;
  }

  // userNameField
  static Widget userNameFieldWidget() {
    //
    final Widget widget = Consumer(builder: (context, ref, child) {
      final nickNameFieldStateNotifierProvider =
          ref.watch(UserPageState.nickNameFieldStateNotifierProviderOfProvider);

      return NameFieldWidget(
        nameFieldStateNotifierProvider: nickNameFieldStateNotifierProvider,
      );
    });

    return widget;
  }

  // userUpdateButton
  static Widget userUpdateButtonWidget() {
    //
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        return OnSubmitButtonWidget(
          onSubmitButtonStateNotifierProvider: ref.watch(
              UserPageState.userUpdateOnSubmitButtonStateNotifierProvider),
        );
      },
    );

    return widget;
  }
}
