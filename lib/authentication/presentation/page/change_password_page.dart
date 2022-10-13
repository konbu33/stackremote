import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widget/login_submit_widget.dart';
import '../widget/password_field_widget.dart';
import 'change_password_page_state.dart';

class ChangePasswordPage extends HookConsumerWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changePasswordPageStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: ChangePasswordPageWidgets.pageTitleWidget(state),
      ),
      body: Form(
        key: state.formKey,
        child: Column(
          children: [
            const SizedBox(height: 40),
            ChangePasswordPageWidgets.passwordField(state),
            const SizedBox(height: 40),
            ChangePasswordPageWidgets.changePasswordButton(state),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordPageWidgets {
  // Page Title
  static Widget pageTitleWidget(ChangePasswordPageState state) {
    final Widget widget = Text(state.pageTitle);
    return widget;
  }

  // Password Field Widget
  static Widget passwordField(ChangePasswordPageState state) {
    final Widget widget = PasswordFieldWidget(
      passwordFieldStateProvider: state.passwordFieldStateProvider,
    );
    return widget;
  }

  // Submit Button
  static Widget changePasswordButton(ChangePasswordPageState state) {
    final Widget widget = LoginSubmitWidget(
      // loginIdFieldStateProvider: state.loginIdFieldStateProvider,
      // passwordFieldStateProvider: state.passwordFieldStateProvider,
      loginSubmitStateProvider: state.onSubmitStateProvider,
    );

    return widget;
  }
}
