import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/state/login_submit_state.dart';

class LoginSubmitWidget extends HookConsumerWidget {
  const LoginSubmitWidget(
      {Key? key,
      required this.name,
      required this.state,
      required this.onSubmit})
      : super(key: key);

  final String name;
  final LoginSubmitState state;
  final Function onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Submitボタン
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
            onPressed: state.loginIdFieldState.isSubmitable &&
                    state.passwordFieldState.isSubmitable
                ? () {
                    onSubmit(
                        state.loginIdFieldState.loginidController.value.text,
                        state.passwordFieldState.passwordController.value.text);

                    state.loginIdFieldStateNotifier.init();
                    state.passwordFieldStateNotifier.init();
                  }
                : null,
            child: Text(name),
          ),
        ),
        Text(
            "${state.loginIdFieldState.isSubmitable}, ${state.passwordFieldState.isSubmitable}"),
      ],
    );
  }
}
