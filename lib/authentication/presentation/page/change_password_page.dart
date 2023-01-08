import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../widget/password_field_widget.dart';
import 'change_password_page_state.dart';

class ChangePasswordPage extends ConsumerWidget {
  const ChangePasswordPage({super.key});

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
                const SizedBox(height: 20),
                Stack(
                  children: [
                    ChangePasswordPageWidgets.attentionMessageWidget(),
                    ChangePasswordPageWidgets.changePasswordProgressWidget(),
                  ],
                ),
                const SizedBox(height: 40),
                ChangePasswordPageWidgets.passwordFieldWidget(),
                const SizedBox(height: 40),
                ChangePasswordPageWidgets.passwordFieldConfirmWidget(),
                const SizedBox(height: 40),
                ChangePasswordPageWidgets.changePasswordButtonWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordPageWidgets {
  // descriptionMessageWidget
  static Widget descriptionMessageWidget() {
    const textStyle = TextStyle(color: Colors.grey);

    final Widget widget = DescriptionMessageWidget(
      descriptionMessageStateProvider:
          ChangePasswordPageState.descriptionMessageStateProvider,
      textStyle: textStyle,
    );

    return widget;
  }

  // attentionMessageWidget
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

  // passwordFieldWidget
  static Widget passwordFieldWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final passwordFieldStateProvider = ref
          .watch(ChangePasswordPageState.passwordFieldStateProviderOfProvider);

      return PasswordFieldWidget(
        passwordFieldStateProvider: passwordFieldStateProvider,
      );
    });

    return widget;
  }

  // passwordFieldConfirmWidget
  static Widget passwordFieldConfirmWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final passwordFieldConfirmStateProvider = ref.watch(
          ChangePasswordPageState.passwordFieldConfirmStateProviderOfProvider);

      return PasswordFieldWidget(
        passwordFieldStateProvider: passwordFieldConfirmStateProvider,
      );
    });

    return widget;
  }

  // changePasswordButtonWidget
  static Widget changePasswordButtonWidget() {
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

  // changePasswordProgressWidget
  static Widget changePasswordProgressWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final signInProgressStateNotifierProvider = ref.watch(
        ChangePasswordPageState
            .changePasswordProgressStateNotifierProviderOfProvider,
      );

      return ProgressWidget(
        progressStateNotifierProvider: signInProgressStateNotifierProvider,
      );
    });

    return widget;
  }
}
