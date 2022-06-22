import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/state/login_form_state.dart';
import '../../application/state/login_submit_state.dart';
import '../../application/state/loginid_field_state.dart';
import '../../application/state/password_field_state.dart';
import '../widget/loginid_field_notifier.dart';
import '../widget/password_field_notifier.dart';
import 'signin_page_state.dart';

class SignInPageNotifier extends StateNotifier<SignInPageState> {
  SignInPageNotifier({
    required LoginFormState loginFormState,
    required LoginSubmitState loginSubmitState,
    required LoginIdFieldState loginIdFieldState,
    required LoginIdFieldStateNotifier loginIdFieldStateNotifier,
    required PasswordFieldState passwordFieldState,
    required PasswordFieldStateNotifier passwordFieldStateNotifier,
    required Function onSubmit,
    required Function useAuth,
  }) : super(SignInPageState.initial(
          loginFormState: loginFormState,
          loginSubmitState: loginSubmitState,
          loginIdFieldState: loginIdFieldState,
          loginIdFieldStateNotifier: loginIdFieldStateNotifier,
          passwordFieldState: passwordFieldState,
          passwordFieldStateNotifier: passwordFieldStateNotifier,
          onSubmit: onSubmit,
          useAuth: useAuth,
        ));
}
