import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../widget/login_submit_widget.dart';
import '../widget/loginid_field_widget.dart';
import '../widget/password_field_widget.dart';

import 'signup_page_state.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpPageStateNotifierProvider);

    final loginIdFieldState = ref.watch(state.loginIdFieldStateProvider);

    final passwordFieldState = ref.watch(state.passwordFieldStateProvider);

    final loginSubmitWidgetName =
        ref.watch(state.loginSubmitStateProvider).loginSubmitWidgetName;

    return Scaffold(
      appBar: AppBar(
        title: Text(loginSubmitWidgetName),
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
    );
  }
}

class SignUpPageWidgets {
  // Login Id Field Widget
  static Widget loginIdField(SignUpPageState state) {
    final Widget widget = LoginIdFieldWidget(
      loginIdFieldStateProvider: state.loginIdFieldStateProvider,
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
    final Widget widget = Consumer(builder: ((context, ref, child) {
      final loginIdIsValidate = ref.watch(state.loginIdFieldStateProvider
          .select((value) => value.loginIdIsValidate.isValid));

      final passwordIsValidate = ref.watch(state.passwordFieldStateProvider
          .select((value) => value.passwordIsValidate.isValid));

      if ((loginIdIsValidate && passwordIsValidate) != state.isOnSubmitable) {
        // improve: addPostFrameCallbackの代替として、StatefulWidgetのmountedなど検討。
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final notifier = ref.watch(signUpPageStateNotifierProvider.notifier);
          notifier
              .updateIsOnSubmitable(passwordIsValidate && loginIdIsValidate);
          notifier.setSignUpOnSubmit();
        });
      }

      return LoginSubmitWidget(
        loginSubmitStateProvider: state.loginSubmitStateProvider,
      );
    }));

    return widget;
  }
}
