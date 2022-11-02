import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../widget/appbar_action_icon_widget.dart';
import '../widget/login_submit_widget.dart';
import '../widget/loginid_field_widget.dart';
import '../widget/password_field_widget.dart';

import 'signin_page_state.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInPageStateNotifierProvider);
    final loginIdFieldState = ref.watch(state.loginIdFieldStateProvider);
    final passwordFieldState = ref.watch(state.passwordFieldStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.loginSubmitWidgetName),
        actions: [
          SignInPageWidgets.goToSignUpWidget(state),
        ],
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
    );
  }
}

class SignInPageWidgets {
  // GoTo SignUp Icon Widget
  static Widget goToSignUpWidget(SignInPageState state) {
    final Widget widget = AppbarAcitonIconWidget(
      appbarActionIconStateProvider: state.goToSignUpIconStateProvider,
    );
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
    final Widget widget = Consumer(builder: (context, ref, child) {
      final loginIdIsValidate = ref.watch(state.loginIdFieldStateProvider
          .select((value) => value.loginIdIsValidate.isValid));

      final passwordIsValidate = ref.watch(state.passwordFieldStateProvider
          .select((value) => value.passwordIsValidate.isValid));

      if ((loginIdIsValidate && passwordIsValidate) != state.isOnSubmitable) {
        // improve: addPostFrameCallbackの代替として、StatefulWidgetのmountedなど検討。
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final notifier = ref.read(signInPageStateNotifierProvider.notifier);
          notifier
              .updateIsOnSubmitable(passwordIsValidate && loginIdIsValidate);
          notifier.setSignInOnSubmit();
        });
      }

      return LoginSubmitWidget(
        loginSubmitStateProvider: state.loginSubmitStateProvider,
      );
    });
    return widget;
  }
}
