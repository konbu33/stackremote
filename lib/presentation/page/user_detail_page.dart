import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widget/login_submit_widget.dart';
import '../widget/loginid_field_widget.dart';
import '../widget/password_field_widget.dart';
import 'user_detail_page_state.dart';

class UserDetailPage extends HookConsumerWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userDetailPageStateControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: UserDetailPageWidgets.pageTitleWidget(state),
      ),
      body: Form(
        key: state.userPageformValueKey,
        child: Column(
          children: [
            const SizedBox(height: 40),
            UserDetailPageWidgets.userNameField(state),
            const SizedBox(height: 40),
            UserDetailPageWidgets.passwordField(state),
            const SizedBox(height: 40),
            state.currentUser == null
                ? UserDetailPageWidgets.userAddButton(state)
                : UserDetailPageWidgets.userUpdateButton(state),
          ],
        ),
      ),
    );
  }
}

class UserDetailPageWidgets {
  // Page Title
  static Widget pageTitleWidget(UserDetailPageState state) {
    final Widget widget = Text(state.pageTitle);
    return widget;
  }

  // User Name Field
  static Widget userNameField(UserDetailPageState state) {
    final Widget widget = LoginIdFieldWidget(
        loginIdFieldStateProvider: state.loginIdFieldStateProvider);

    return widget;
  }

  // Password Field
  static Widget passwordField(UserDetailPageState state) {
    final Widget widget = PasswordFieldWidget(
        passwordFieldStateProvider: state.passwordFieldStateProvider);

    return widget;
  }

  // User Add Button
  static Widget userAddButton(UserDetailPageState state) {
    final Widget widget = LoginSubmitWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
      passwordFieldStateProvider: state.passwordFieldStateProvider,
      loginSubmitStateProvider: state.userAddSubmitStateProvider,
    );

    return widget;
  }

  // User Update Button
  static Widget userUpdateButton(UserDetailPageState state) {
    final Widget widget = LoginSubmitWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
      passwordFieldStateProvider: state.passwordFieldStateProvider,
      loginSubmitStateProvider: state.userUpdateSubmitStateProvider,
    );

    return widget;
  }
}
