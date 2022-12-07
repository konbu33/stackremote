import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../authentication.dart';

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
            // ref
            //     .read(SignInPageState.isSignUpPagePushProvider.notifier)
            //     .update((state) => false);
            ref
                .read(authenticationRoutingCurrentPathProvider.notifier)
                .update((state) => AuthenticationRoutingPath.signIn);
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
                Stack(
                  children: [
                    SignUpPageWidgets.attentionMessageWidget(),
                    SignUpPageWidgets.signUpProgressWidget(),
                  ],
                ),
                const SizedBox(height: 30),
                SignUpPageWidgets.loginIdFieldWidget(),
                const SizedBox(height: 30),
                SignUpPageWidgets.passwordFieldWidget(),
                const SizedBox(height: 40),
                SignUpPageWidgets.signUpOnSubmitWidget(),
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

  // loginIdFieldWidget
  static Widget loginIdFieldWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final loginIdFieldStateNotifierProvider = ref
          .watch(SignUpPageState.loginIdFieldStateNotifierProviderOfProvider);

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
          ref.watch(SignUpPageState.passwordFieldStateProviderOfProvider);

      return PasswordFieldWidget(
        passwordFieldStateProvider: passwordFieldStateProvider,
      );
    });
    return widget;
  }

  // signUpOnSubmitWidget
  static Widget signUpOnSubmitWidget() {
    final Widget widget = Consumer(builder: ((context, ref, child) {
      return OnSubmitButtonWidget(
        onSubmitButtonStateNotifierProvider: ref
            .watch(SignUpPageState.signUpOnSubmitButtonStateNotifierProvider),
      );
    }));

    return widget;
  }

  // signUpProgressWidget
  static Widget signUpProgressWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final signUpProgressStateNotifierProvider = ref
          .watch(SignUpPageState.signUpProgressStateNotifierProviderOfProvider);

      return ProgressWidget(
        progressStateNotifierProvider: signUpProgressStateNotifierProvider,
      );
    });

    return widget;
  }
}
