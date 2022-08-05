import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/state/login_form_state.dart';

class LoginFormStateNotifier extends StateNotifier<LoginFormState> {
  LoginFormStateNotifier() : super(LoginFormState.initial());

  void init() {
    state = LoginFormState.initial();
  }
}
