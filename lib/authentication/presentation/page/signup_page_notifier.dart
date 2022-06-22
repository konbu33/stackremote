import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/state/login_form_state.dart';
import '../../application/state/login_submit_state.dart';
import '../../application/state/loginid_field_state.dart';
import '../../application/state/password_field_state.dart';
import '../widget/loginid_field_notifier.dart';
import '../widget/password_field_notifier.dart';
import 'signup_page_state.dart';

class SignUpPageStateNotifier extends StateNotifier<SignUpPageState> {
  SignUpPageStateNotifier({
    required LoginFormState loginFormState,
    required LoginIdFieldState loginIdFieldState,
    required LoginIdFieldStateNotifier loginIdFieldStateNotifier,
    required PasswordFieldState passwordFieldState,
    required PasswordFieldStateNotifier passwordFieldStateNotifier,
    required LoginSubmitState loginSubmitState,
    required Function onSubmit,
    required Function useAuth,
  }) : super(
          SignUpPageState(
            loginFormState: loginFormState,
            loginIdFieldState: loginIdFieldState,
            loginIdFieldStateNotifier: loginIdFieldStateNotifier,
            passwordFieldState: passwordFieldState,
            passwordFieldStateNotifier: passwordFieldStateNotifier,
            loginSubmitState: loginSubmitState,
            onSubmit: onSubmit,
            useAuth: useAuth,
          ),
        );
}
