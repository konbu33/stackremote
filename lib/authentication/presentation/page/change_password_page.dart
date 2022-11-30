import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../../common/widget/description_message_widget.dart';
import '../widget/login_submit_widget.dart';
import '../widget/password_field_widget.dart';

import 'change_password_page_state.dart';

class ChangePasswordPage extends HookConsumerWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordField =
        ref.watch(ChangePasswordPageState.passwordFieldStateProvider);

    final passwordFieldConfirm =
        ref.watch(ChangePasswordPageState.passwordFieldConfirmStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: ChangePasswordPageWidgets.pageTitleWidget(),
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
  // Page Title
  static Widget pageTitleWidget() {
    const Widget widget = Text(ChangePasswordPageState.pageTitle);
    return widget;
  }

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
    final Widget widget = PasswordFieldWidget(
      passwordFieldStateProvider:
          ChangePasswordPageState.passwordFieldStateProvider,
    );
    return widget;
  }

  // Password Field Widget
  static Widget passwordFieldConfirm() {
    final Widget widget = PasswordFieldWidget(
      passwordFieldStateProvider:
          ChangePasswordPageState.passwordFieldConfirmStateProvider,
    );
    return widget;
  }

  // Submit Button
  static Widget changePasswordButton() {
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        return LoginSubmitWidget(
          loginSubmitStateProvider:
              ref.watch(ChangePasswordPageState.onSubmitStateProvider),
        );
      },
    );

    return widget;
  }
}
