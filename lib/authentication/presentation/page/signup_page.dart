import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../widget/login_submit_widget.dart';
import '../widget/loginid_field_widget.dart';
import '../widget/password_field_widget.dart';

import 'signin_page_state.dart';
import 'signup_page_state.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginIdFieldState =
        ref.watch(SignUpPageState.loginIdFieldStateProvider);

    final passwordFieldState =
        ref.watch(SignUpPageState.passwordFieldStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(SignUpPageState.loginSubmitWidgetName),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            ref
                .read(SignInPageState.isSignUpPagePushProvider.notifier)
                .update((state) => false);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: [
          loginIdFieldState.focusNode,
          passwordFieldState.focusNode,
        ],
        children: [
          Form(
            key: GlobalKey<FormState>(),
            child: Column(
              children: [
                SignUpPageWidgets.loginIdField(),
                const SizedBox(height: 30),
                SignUpPageWidgets.passwordField(),
                const SizedBox(height: 40),
                SignUpPageWidgets.loginSubmitWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpPageWidgets {
  // Login Id Field Widget
  static Widget loginIdField() {
    final Widget widget = LoginIdFieldWidget(
      loginIdFieldStateProvider: SignUpPageState.loginIdFieldStateProvider,
    );
    return widget;
  }

  // Password Field Widget
  static Widget passwordField() {
    final Widget widget = PasswordFieldWidget(
      passwordFieldStateProvider: SignUpPageState.passwordFieldStateProvider,
    );
    return widget;
  }

  // Login Submit Widget
  static Widget loginSubmitWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      return LoginSubmitWidget(
        loginSubmitStateProvider:
            ref.watch(SignUpPageState.loginSubmitStateProvider),
      );
    }));

    return widget;
  }
}
