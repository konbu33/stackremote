import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginSubmitWidget extends HookConsumerWidget {
  const LoginSubmitWidget({
    Key? key,
    required this.loginIdFieldStateProvider,
    required this.passwordFieldStateProvider,
    required this.loginSubmitStateProvider,
  }) : super(key: key);

  final loginIdFieldStateProvider;
  final passwordFieldStateProvider;
  final loginSubmitStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginIdFieldState = ref.watch(loginIdFieldStateProvider);
    final loginIdFieldStateNotifier =
        ref.read(loginIdFieldStateProvider.notifier);

    final passwordFieldState = ref.watch(passwordFieldStateProvider);
    final passwordFieldStateNotifier =
        ref.read(passwordFieldStateProvider.notifier);

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
            onPressed: loginIdFieldState.loginIdIsValidate.isValid &&
                    passwordFieldState.passwordIsValidate.isValid
                ? () {
                    final String email =
                        loginIdFieldState.loginIdFieldController.text;
                    final String password =
                        passwordFieldState.passwordFieldController.text;

                    loginIdFieldStateNotifier.initial();
                    passwordFieldStateNotifier.initial();
                    loginSubmitState.onSubmit(email, password);
                  }
                : null,
            child: Text(loginSubmitState.loginSubmitWidgetName),
          ),
        ),
      ],
    );
  }
}
