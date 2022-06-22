import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/state/password_field_state.dart';

class PasswordFieldStateNotifier extends StateNotifier<PasswordFieldState> {
  PasswordFieldStateNotifier() : super(PasswordFieldState.initial());

  void init() {
    state = PasswordFieldState.initial();
  }

  void changeIsSubmitable() {
    state = state.copyWith(isSubmitable: false, validateSuccess: false);
    if (state.passwordKey.value.currentState!.validate()) {
      state = state.copyWith(
          isSubmitable: true,
          validateSuccess: state.passwordKey.value.currentState!.validate());
    }
  }

  void toggleObscureText() {
    state = state.copyWith(isObscure: !state.isObscure);
  }

  String? customValidator(String? value) {
    if (value == null) return "Null!  Please enter some text password";
    if (value.isEmpty) return "Empty! Please enter some text password";
    if (value.length < state.minLength) {
      return "Min lenght: ${state.minLength}, Max length : ${state.maxLength}.";
    }
    return null;
  }

  void changeValidatorMessage(String message) {
    state = state.copyWith(validatorMessage: message);
  }
}
