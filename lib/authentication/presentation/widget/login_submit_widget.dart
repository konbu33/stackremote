import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'login_submit_state.dart';

class LoginSubmitWidget extends HookConsumerWidget {
  const LoginSubmitWidget({
    Key? key,
    required this.loginSubmitStateProvider,
  }) : super(key: key);

  final LoginSubmitStateProvider loginSubmitStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            child: Text(loginSubmitState.loginSubmitWidgetName),
          ),
        ),
      ],
    );
  }
}
