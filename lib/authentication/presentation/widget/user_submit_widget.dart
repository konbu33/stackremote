import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user_detail_page_state.dart';

class UserSubmitWidget extends HookConsumerWidget {
  const UserSubmitWidget({
    Key? key,
    required this.userDetailPageStateProvider,
    required this.userSubmitStateProvider,
  }) : super(key: key);

  final StateNotifierProvider<UserDetailPageStateController,
      UserDetailPageState> userDetailPageStateProvider;
  final userSubmitStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetailPageState = ref.watch(userDetailPageStateProvider);

    final loginIdFieldState =
        ref.watch(userDetailPageState.loginIdFieldStateProvider);

    final passwordFieldState =
        ref.watch(userDetailPageState.passwordFieldStateProvider);

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

                    state.onSubmit(
                      context: context,
                      email: email,
                      password: password,
                    );
                  }
                : null,
            child: Text(state.userSubmitWidgetName),
          ),
        ),
      ],
    );
  }
}
