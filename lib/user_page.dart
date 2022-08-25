import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user_add_icon_widget.dart';
import 'package:stackremote/user_list_widget.dart';

import 'authentication/presentation/widget/signout_widget.dart';
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
          UserPageWidgets.signOutButton(),
        ],
      ),
      body: Column(
        children: [
          UserPageWidgets.userListWidget(state),
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
    final Widget widget = UserAddIconWidget(
      state: state,
      notifier: notifier,
    );

    return widget;
  }

  // signOutButton
  static Widget signOutButton() {
    const Widget widget = SignOutWidget();

    return widget;
  }

  static Widget userListWidget(
    UserPageState state,
  ) {
    final widget = UserListWidget(
      state: state,
    );

    return widget;
  }
}
