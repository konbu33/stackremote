import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/state/loginid_field_state.dart';

class LoginIdFieldStateNotifier extends StateNotifier<LoginIdFieldState> {
  LoginIdFieldStateNotifier() : super(LoginIdFieldState.initial());

  void init() {
    state = LoginIdFieldState.initial();
  }

  void changeIsSubmitable() {
    state = state.copyWith(isSubmitable: false, validateSuccess: false);
    if (state.loginidKey.value.currentState!.validate()) {
      state = state.copyWith(
          isSubmitable: true,
          validateSuccess: state.loginidKey.value.currentState!.validate());
    }
  }

  String? customValidator(String? value) {
    if (value == null) return "Null!  Please enter some text loginid.";
    if (value.isEmpty) return "Empty! Please enter some text loginid.";
    if (value.length < state.minLength) {
      return "Min lenght: ${state.minLength}, Max length : ${state.maxLength}.";
    }
    return null;
  }

  void changeValidatorMessage(String message) {
    state = state.copyWith(validatorMessage: message);
  }
}
