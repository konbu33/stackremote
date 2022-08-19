import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserSubmitWidget extends HookConsumerWidget {
  const UserSubmitWidget({
    Key? key,
    required this.loginIdFieldStateProvider,
    required this.passwordFieldStateProvider,
    required this.userSubmitStateProvider,
  }) : super(key: key);

  final loginIdFieldStateProvider;
  final passwordFieldStateProvider;
  final userSubmitStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginIdFieldState = ref.watch(loginIdFieldStateProvider);
    final loginIdFieldStateNotifier =
        ref.read(loginIdFieldStateProvider.notifier);

    final passwordFieldState = ref.watch(passwordFieldStateProvider);
    final passwordFieldStateNotifier =
        ref.read(passwordFieldStateProvider.notifier);

    final state = ref.watch(userSubmitStateProvider);

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
                    state.onSubmit(email, password);

                    loginIdFieldStateNotifier.initial();
                    passwordFieldStateNotifier.initial();

                    Navigator.pop(context);
                  }
                : null,
            child: Text(state.userSubmitWidgetName),
          ),
        ),
      ],
    );
  }
}
