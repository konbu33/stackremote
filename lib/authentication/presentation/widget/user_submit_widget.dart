import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'loginid_field_state.dart';
import 'password_field_state.dart';
import 'user_submit_state.dart';

class UserSubmitWidget extends HookConsumerWidget {
  const UserSubmitWidget({
    Key? key,
    required this.loginIdFieldStateProvider,
    required this.passwordFieldStateProvider,
    required this.userSubmitStateProvider,
  }) : super(key: key);

  final LoginIdFieldStateProvider loginIdFieldStateProvider;
  final PasswordFieldStateProvider passwordFieldStateProvider;
  final UserSubmitStateProvider userSubmitStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginIdFieldState = ref.watch(loginIdFieldStateProvider);
    final passwordFieldState = ref.watch(passwordFieldStateProvider);
    final userSubmitState = ref.watch(userSubmitStateProvider);

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

                    userSubmitState.onSubmit(
                      context: context,
                      email: email,
                      password: password,
                    );
                  }
                : null,
            child: Text(userSubmitState.userSubmitWidgetName),
          ),
        ),
      ],
    );
  }
}
