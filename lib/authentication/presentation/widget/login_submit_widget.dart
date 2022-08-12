import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/presentation/widget/loginid_field_state.dart';

import 'login_submit_state.dart';
import 'password_field_state.dart';

class LoginSubmitWidget extends HookConsumerWidget {
  const LoginSubmitWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginIdFieldState = ref.watch(loginIdFieldStateNotifierProvider);
    final loginIdFieldStateNotifier =
        ref.read(loginIdFieldStateNotifierProvider.notifier);

    final passwordFieldState = ref.watch(passwordFieldStateNotifierProvider);
    final passwordFieldStateNotifier =
        ref.read(passwordFieldStateNotifierProvider.notifier);

    final state = ref.watch(loginSubmitStateNotifierProvider);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            )),
            onPressed: loginIdFieldState.loginIdIsValidate.isValid &&
                    passwordFieldState.passwordIsValidate.isValid
                ? () {
                    final String email =
                        loginIdFieldState.loginIdFieldController.text;
                    final String password =
                        passwordFieldState.passwordFieldController.text;
                    state.signIn(email, password);

                    loginIdFieldStateNotifier.initial();
                    passwordFieldStateNotifier.initial();
                  }
                : null,
            child: Text(state.loginSubmitWidgetName),
          ),
        ),
      ],
    );
  }
}
