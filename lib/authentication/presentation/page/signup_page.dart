import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../widget/password_field_widget.dart';

import 'signin_page_state.dart';
import 'signup_page_state.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginIdFieldStateNotifierProvider =
        ref.watch(SignUpPageState.loginIdFieldStateNotifierProviderOfProvider);

    final loginIdFieldState = ref.watch(loginIdFieldStateNotifierProvider);

    final passwordFieldStateProvider =
        ref.watch(SignUpPageState.passwordFieldStateProviderOfProvider);

    final passwordFieldState = ref.watch(passwordFieldStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(SignUpPageState.pageTitle),
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
                SignUpPageWidgets.attentionMessageWidget(),
                const SizedBox(height: 30),
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
  // attentionMessageWidget
  static Widget attentionMessageWidget() {
    const textStyle = TextStyle(color: Colors.red);
    final Widget widget = DescriptionMessageWidget(
      descriptionMessageStateProvider:
          SignUpPageState.attentionMessageStateProvider,
      textStyle: textStyle,
    );
    return widget;
  }

  // Login Id Field Widget
  static Widget loginIdField() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final loginIdFieldStateNotifierProvider = ref
          .watch(SignUpPageState.loginIdFieldStateNotifierProviderOfProvider);

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
          ref.watch(SignUpPageState.passwordFieldStateProviderOfProvider);

      return PasswordFieldWidget(
        passwordFieldStateProvider: passwordFieldStateProvider,
      );
    });
    return widget;
  }

  // Login Submit Widget
  static Widget loginSubmitWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      return OnSubmitButtonWidget(
        onSubmitButtonStateNotifierProvider: ref
            .watch(SignUpPageState.signUpOnSubmitButtonStateNotifierProvider),
      );
    }));

    return widget;
  }
}
