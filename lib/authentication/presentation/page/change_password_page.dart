import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../widget/password_field_widget.dart';

import 'change_password_page_state.dart';

class ChangePasswordPage extends HookConsumerWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordFieldStateProvider =
        ref.watch(ChangePasswordPageState.passwordFieldStateProviderOfProvider);

    final passwordField = ref.watch(passwordFieldStateProvider);

    final passwordFieldConfirmStateProvider = ref.watch(
        ChangePasswordPageState.passwordFieldConfirmStateProviderOfProvider);

    final passwordFieldConfirm = ref.watch(passwordFieldConfirmStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(ChangePasswordPageState.pageTitle),
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: [
          passwordField.focusNode,
          passwordFieldConfirm.focusNode,
        ],
        children: [
          Form(
            key: GlobalKey<FormState>(),
            child: Column(
              children: [
                ChangePasswordPageWidgets.descriptionMessageWidget(),
                ChangePasswordPageWidgets.attentionMessageWidget(),
                const SizedBox(height: 40),
                ChangePasswordPageWidgets.passwordField(),
                const SizedBox(height: 40),
                ChangePasswordPageWidgets.passwordFieldConfirm(),
                const SizedBox(height: 40),
                ChangePasswordPageWidgets.changePasswordButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordPageWidgets {
  // Description
  static Widget descriptionMessageWidget() {
    const textStyle = TextStyle(color: Colors.grey);

    final Widget widget = DescriptionMessageWidget(
      descriptionMessageStateProvider:
          ChangePasswordPageState.descriptionMessageStateProvider,
      textStyle: textStyle,
    );
    return widget;
  }

  // Message
  static Widget attentionMessageWidget() {
    const textStyle = TextStyle(color: Colors.red);

    final Widget widget = Consumer(builder: (context, ref, child) {
      return DescriptionMessageWidget(
        descriptionMessageStateProvider:
            ChangePasswordPageState.attentionMessageStateProvider,
        textStyle: textStyle,
      );
    });
    return widget;
  }

  // Password Field Widget
  static Widget passwordField() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final passwordFieldStateProvider = ref
          .watch(ChangePasswordPageState.passwordFieldStateProviderOfProvider);

      return PasswordFieldWidget(
        passwordFieldStateProvider: passwordFieldStateProvider,
      );
    });
    return widget;
  }

  // Password Field Widget
  static Widget passwordFieldConfirm() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final passwordFieldConfirmStateProvider = ref.watch(
          ChangePasswordPageState.passwordFieldConfirmStateProviderOfProvider);

      return PasswordFieldWidget(
        passwordFieldStateProvider: passwordFieldConfirmStateProvider,
      );
    });
    return widget;
  }

  // Submit Button
  static Widget changePasswordButton() {
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        return OnSubmitButtonWidget(
          onSubmitButtonStateNotifierProvider: ref.watch(ChangePasswordPageState
              .changePasswordOnSubmitButtonStateNotifierProvider),
        );
      },
    );

    return widget;
  }
}
