import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widget/background_image_widget.dart';
import '../widget/base_layout_widget.dart';

import '../widget/login_submit_widget.dart';
import '../widget/loginid_field_widget.dart';
import '../widget/password_field_widget.dart';
import '../widget/go_to_signup_icon_widget.dart';
import 'signin_page_state.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInPageStateNotifierProvider);

    return BackgroundImageWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(state.loginSubmitWidgetName),
          actions: [
            SignInPageWidgets.singUpWidget(state),
          ],
        ),
        body: BaseLayoutWidget(
          children: [
            Form(
              key: GlobalKey<FormState>(),
              child: Column(
                children: [
                  SignInPageWidgets.loginIdField(state),
                  const SizedBox(height: 30),
                  SignInPageWidgets.passwordField(state),
                  const SizedBox(height: 40),
                  SignInPageWidgets.loginSubmitWidget(state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInPageWidgets {
  // SignUp Widget
  static Widget singUpWidget(SignInPageState state) {
    const Widget widget = GoToSignUpWidget();
    return widget;
  }

  // Login Id Field Widget
  static Widget loginIdField(SignInPageState state) {
    final Widget widget = LoginIdFieldWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
    );
    return widget;
  }

  // Password Field Widget
  static Widget passwordField(SignInPageState state) {
    final Widget widget = PasswordFieldWidget(
      passwordFieldStateProvider: state.passwordFieldStateProvider,
    );
    return widget;
  }

  // Login Submit Widget
  static Widget loginSubmitWidget(SignInPageState state) {
    final Widget widget = LoginSubmitWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
      passwordFieldStateProvider: state.passwordFieldStateProvider,
      loginSubmitStateProvider: state.loginSubmitStateProvider,
    );
    return widget;
  }
}
