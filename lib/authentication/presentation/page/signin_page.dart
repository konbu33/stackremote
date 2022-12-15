import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          SignInPageWidgets.goToSignUpIconWidget(),
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
                Stack(
                  children: [
                    SignInPageWidgets.attentionMessageWidget(),
                    SignInPageWidgets.signInProgressWidget(),
                  ],
                ),
                const SizedBox(height: 30),
                SignInPageWidgets.loginIdFieldWidget(),
                const SizedBox(height: 30),
                SignInPageWidgets.passwordFieldWidget(),
                const SizedBox(height: 40),
                SignInPageWidgets.signInOnSubmitWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignInPageWidgets {
  // goToSignUpIconWidget
  static Widget goToSignUpIconWidget() {
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

  // loginIdFieldWidget
  static Widget loginIdFieldWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final loginIdFieldStateNotifierProvider = ref
          .watch(SignInPageState.loginIdFieldStateNotifierProviderOfProvider);

      return NameFieldWidget(
        nameFieldStateNotifierProvider: loginIdFieldStateNotifierProvider,
      );
    });
    return widget;
  }

  // passwordFieldWidget
  static Widget passwordFieldWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final passwordFieldStateProvider =
          ref.watch(SignInPageState.passwordFieldStateProviderOfProvider);

      return PasswordFieldWidget(
        passwordFieldStateProvider: passwordFieldStateProvider,
      );
    });
    return widget;
  }

  // loginOnSubmitWidget
  static Widget signInOnSubmitWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      return OnSubmitButtonWidget(
        onSubmitButtonStateNotifierProvider: ref
            .watch(SignInPageState.signInOnSubmitButtonStateNotifierProvider),
      );
    });

    return widget;
  }

  // signInProgressWidget
  static Widget signInProgressWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final signInProgressStateNotifierProvider = ref
          .watch(SignInPageState.signInProgressStateNotifierProviderOfProvider);

      return ProgressWidget(
        progressStateNotifierProvider: signInProgressStateNotifierProvider,
      );
    });

    return widget;
  }
}
