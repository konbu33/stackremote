import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/presentation/widget/user_list_widget.dart';

import '../../../authentication/presentation/widget/appbar_action_icon_widget.dart';
import 'user_detail_page_state.dart';
import 'user_page_state.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userPageStateControllerProvider);
    final notifier = ref.read(userDetailPageStateControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: UserPageWidgets.pageTitleWidget(state),
        actions: [
          UserPageWidgets.userAddButton(state, notifier),
          UserPageWidgets.signOutIconButton(state),
        ],
      ),
      body: Column(
        children: [
          UserPageWidgets.userListWidget(state),
          UserPageWidgets.goToAgoraVideoPage(),
        ],
      ),
    );
  }
}

class UserPageWidgets {
  // pageTitleWidget
  static Widget pageTitleWidget(
    UserPageState state,
  ) {
    final Widget widget = Text(state.pageTitle);

    return widget;
  }

  //  userAddButton
  static Widget userAddButton(
    UserPageState state,
    UserDetailPageStateController notifier,
  ) {
    final Widget widget = AppbarAcitonIconWidget(
      appbarActionIconStateProvider: state.userAddIconStateProvider,
    );

    return widget;
  }

  // signOutIconButton
  static Widget signOutIconButton(UserPageState state) {
    final Widget widget = AppbarAcitonIconWidget(
      appbarActionIconStateProvider: state.signOutIconStateProvider,
    );

    return widget;
  }

  // userListWidget
  static Widget userListWidget(
    UserPageState state,
  ) {
    final widget = UserListWidget(
      state: state,
    );

    return widget;
  }

  // goToAgoraVideoPage
  static Widget goToAgoraVideoPage() {
    final widget = Builder(
      builder: (context) => ElevatedButton(
        onPressed: () {
          context.push("/agoravideo");
        },
        child: const Text("Go To Agora Video"),
      ),
    );

    return widget;
  }
}
