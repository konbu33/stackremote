import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'login_submit_state.dart';
// import 'loginid_field_state.dart';
// import 'password_field_state.dart';

class LoginSubmitWidget extends HookConsumerWidget {
  const LoginSubmitWidget({
    Key? key,
    // required this.loginIdFieldStateProvider,
    // required this.passwordFieldStateProvider,
    required this.loginSubmitStateProvider,
  }) : super(key: key);

  // final LoginIdFieldStateProvider loginIdFieldStateProvider;
  // final PasswordFieldStateProvider passwordFieldStateProvider;
  final LoginSubmitStateProvider loginSubmitStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final loginIdFieldState = ref.watch(loginIdFieldStateProvider);
    // final passwordFieldState = ref.watch(passwordFieldStateProvider);
    final loginSubmitState = ref.watch(loginSubmitStateProvider);

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
            onPressed: loginSubmitState.onSubmit == null
                ? null
                : loginSubmitState.onSubmit!(context: context),
            // onPressed: loginIdFieldState.loginIdIsValidate.isValid &&
            //         passwordFieldState.passwordIsValidate.isValid
            //     ? () {
            //         loginSubmitState.onSubmit(
            //           context: context,
            //         );
            //       }
            //     : null,
            child: Text(loginSubmitState.loginSubmitWidgetName),
          ),
        ),
      ],
    );
  }
}
