import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../widget/password_field_widget.dart';

import 'signin_page_state.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginIdFieldStateNotifierProvider =
        ref.watch(SignInPageState.loginIdFieldStateNotifierProviderOfProvider);

    final loginIdFieldState = ref.watch(loginIdFieldStateNotifierProvider);

    final passwordFieldStateProvider =
        ref.watch(SignInPageState.passwordFieldStateProviderOfProvider);

    final passwordFieldState = ref.watch(passwordFieldStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(SignInPageState.pageTitle),
        actions: [
          SignInPageWidgets.goToSignUpWidget(),
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
                SignInPageWidgets.attentionMessageWidget(),
                const SizedBox(height: 30),
                SignInPageWidgets.loginIdField(),
                const SizedBox(height: 30),
                SignInPageWidgets.passwordField(),
                const SizedBox(height: 40),
                SignInPageWidgets.loginSubmitWidget(),
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
  static Widget goToSignUpWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      return AppbarAcitonIconWidget(
        appbarActionIconStateNotifierProvider:
            ref.watch(SignInPageState.goToSignUpIconStateProvider),
      );
    });
    return widget;
  }

  // attentionMessageWidget
  static Widget attentionMessageWidget() {
    const textStyle = TextStyle(color: Colors.red);
    final Widget widget = DescriptionMessageWidget(
      descriptionMessageStateProvider:
          SignInPageState.attentionMessageStateProvider,
      textStyle: textStyle,
    );
    return widget;
  }

  // Login Id Field Widget
  static Widget loginIdField() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final loginIdFieldStateNotifierProvider = ref
          .watch(SignInPageState.loginIdFieldStateNotifierProviderOfProvider);

      return NameFieldWidget(
        nameFieldStateNotifierProvider: loginIdFieldStateNotifierProvider,
      );
    });
    return widget;
  }

  // Password Field Widget
  static Widget passwordField() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final passwordFieldStateProvider =
          ref.watch(SignInPageState.passwordFieldStateProviderOfProvider);

      return PasswordFieldWidget(
        passwordFieldStateProvider: passwordFieldStateProvider,
      );
    });
    return widget;
  }

  // Login Submit Widget
  static Widget loginSubmitWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      return OnSubmitButtonWidget(
        onSubmitButtonStateNotifierProvider: ref
            .watch(SignInPageState.signInOnSubmitButtonStateNotifierProvider),
      );
    });
    return widget;
  }
}
