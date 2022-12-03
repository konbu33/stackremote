import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'validation.dart';

final customValidatorProvider = Provider((ref) {
  Validation customValidator(String value) {
    const minLength = 8;
    const maxLength = 20;

    const defaultMessage = "";
    const emptyMessage = "";
    const minMaxLenghtMessage = "$minLength文字以上、$maxLength文字以下で入力して下さい。";

    if (value.isEmpty) {
      final validation =
          Validation.create(isValid: false, message: emptyMessage);
      // state = state.copyWith(isValidate: validation);
      return validation;
    }

    if (value.length < minLength) {
      final validation =
          Validation.create(isValid: false, message: minMaxLenghtMessage);
      // state = state.copyWith(isValidate: validation);
      return validation;
    }

    final validation =
        Validation.create(isValid: true, message: defaultMessage);

    // state = state.copyWith(isValidate: validation);
    return validation;
  }

  return customValidator;
});
