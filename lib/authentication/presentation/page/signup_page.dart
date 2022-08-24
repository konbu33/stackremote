import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widget/background_image_widget.dart';
import '../widget/base_layout_widget.dart';

import '../widget/login_submit_widget.dart';
import '../widget/loginid_field_widget.dart';
import '../widget/password_field_widget.dart';
import 'signup_page_state.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpPageStateNotifierProvider);

    final loginSubmitWidgetName =
        ref.read(state.loginSubmitStateProvider).loginSubmitWidgetName;

    return BackgroundImageWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(loginSubmitWidgetName),
        ),
        body: BaseLayoutWidget(
          children: [
            Form(
              key: GlobalKey<FormState>(),
              child: Column(
                children: [
                  SignUpPageWidgets.loginIdField(state),
                  const SizedBox(height: 30),
                  SignUpPageWidgets.passwordField(state),
                  const SizedBox(height: 40),
                  SignUpPageWidgets.loginSubmitWidget(state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPageWidgets {
  // Login Id Field Widget
  static Widget loginIdField(SignUpPageState state) {
    final Widget widget = LoginIdFieldWidget(
      loginIdFieldstateProvider: state.loginIdFieldStateProvider,
    );
    return widget;
  }

  // Password Field Widget
  static Widget passwordField(SignUpPageState state) {
    final Widget widget = PasswordFieldWidget(
      passwordFieldStateProvider: state.passwordFieldStateProvider,
    );
    return widget;
  }

  // Login Submit Widget
  static Widget loginSubmitWidget(SignUpPageState state) {
    final Widget widget = LoginSubmitWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
      passwordFieldStateProvider: state.passwordFieldStateProvider,
      loginSubmitStateProvider: state.loginSubmitStateProvider,
    );
    return widget;
  }
}
