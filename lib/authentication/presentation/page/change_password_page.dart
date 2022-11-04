import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../widget/login_submit_widget.dart';
import '../widget/password_field_widget.dart';

import 'change_password_page_state.dart';

class ChangePasswordPage extends HookConsumerWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changePasswordPageStateProvider);
    final passwordField = ref.watch(state.passwordFieldStateProvider);
    final passwordFieldConfirm =
        ref.watch(state.passwordFieldConfirmStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: ChangePasswordPageWidgets.pageTitleWidget(state),
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: [
          passwordField.focusNode,
          passwordFieldConfirm.focusNode,
        ],
        children: [
          Form(
            key: state.formKey,
            child: Column(
              children: [
                ChangePasswordPageWidgets.descriptionWidget(state),
                ChangePasswordPageWidgets.messageWidget(state),
                const SizedBox(height: 40),
                ChangePasswordPageWidgets.passwordField(state),
                const SizedBox(height: 40),
                ChangePasswordPageWidgets.passwordFieldConfirm(state),
                const SizedBox(height: 40),
                ChangePasswordPageWidgets.changePasswordButton(state),
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
  static Widget pageTitleWidget(ChangePasswordPageState state) {
    final Widget widget = Text(state.pageTitle);
    return widget;
  }

  // Description
  static Widget descriptionWidget(ChangePasswordPageState state) {
    const String descriptionMessage = "入力間違い防止のため、2回入力して下さい。";
    const style = TextStyle(color: Colors.grey);
    const Widget widget = Text(
      descriptionMessage,
      style: style,
    );
    return widget;
  }

  // Message
  static Widget messageWidget(ChangePasswordPageState state) {
    if (state.message.isEmpty) return const SizedBox();

    const style = TextStyle(color: Colors.red);
    final Widget widget = Column(children: [
      const SizedBox(height: 20),
      Text(
        state.message,
        style: style,
      ),
    ]);
    return widget;
  }

  // Password Field Widget
  static Widget passwordField(ChangePasswordPageState state) {
    final Widget widget = PasswordFieldWidget(
      passwordFieldStateProvider: state.passwordFieldStateProvider,
    );
    return widget;
  }

  // Password Field Widget
  static Widget passwordFieldConfirm(ChangePasswordPageState state) {
    final Widget widget = PasswordFieldWidget(
      passwordFieldStateProvider: state.passwordFieldConfirmStateProvider,
    );
    return widget;
  }

  // Submit Button
  static Widget changePasswordButton(ChangePasswordPageState state) {
    final Widget widget = Consumer(
      builder: (context, ref, child) {
        bool checkPasswordIsValidate() {
          final notifier = ref.read(changePasswordPageStateProvider.notifier);
          const String disagreementMessage = "入力したパスワードが不一致です。";

          // 各TextFormFieldのisValidateを確認
          final passwordIsValidate = ref.watch(state.passwordFieldStateProvider
              .select((value) => value.passwordIsValidate.isValid));

          final passwordIsValidateConfirm = ref.watch(state
              .passwordFieldConfirmStateProvider
              .select((value) => value.passwordIsValidate.isValid));

          if (!passwordIsValidate || !passwordIsValidateConfirm) {
            if (state.message.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                notifier.setMessage("");
              });
            }

            return false;
          }

          // TextFormField間でtextの一致を確認
          final passwordFieldState = ref.read(state.passwordFieldStateProvider);
          final passwordFieldConfirmState =
              ref.read(state.passwordFieldConfirmStateProvider);

          final passwordText = passwordFieldState.passwordFieldController.text;

          final passwordTextConfirm =
              passwordFieldConfirmState.passwordFieldController.text;

          if (passwordText != passwordTextConfirm) {
            if (state.message != disagreementMessage) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                notifier.setMessage(disagreementMessage);
              });
            }
            return false;
          }

          if (state.message == disagreementMessage) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              notifier.setMessage("");
            });
          }

          return true;
        }

        final passwordIsValidate = checkPasswordIsValidate();
        logger.d("----------- $passwordIsValidate, ${state.isOnSubmitable}");

        if (passwordIsValidate != state.isOnSubmitable) {
          // improve: addPostFrameCallbackの代替として、StatefulWidgetのmountedなど検討。
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final notifier = ref.read(changePasswordPageStateProvider.notifier);
            notifier.updateIsOnSubmitable(passwordIsValidate);
            notifier.setChangePasswordOnSubmit();
          });
        }

        final a = ref.watch(state.onSubmitStateProvider).onSubmit;
        logger.d(" ---- $a");

        return LoginSubmitWidget(
          loginSubmitStateProvider: state.onSubmitStateProvider,
        );
      },
    );

    return widget;
  }
}
