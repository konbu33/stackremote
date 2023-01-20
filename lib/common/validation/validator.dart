import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../util/min_max.dart';
import 'validation.dart';

typedef MinMaxLenghtValidator = Validation Function(String?);

final minMaxLenghtValidatorProvider =
    Provider.family<MinMaxLenghtValidator, MinMax<int>>((ref, minMax) {
  Validation minMaxLenghtValidator(String? value) {
    final int minLength = minMax.min;
    final int maxLength = minMax.max;

    const defaultMessage = "";
    const emptyMessage = "";
    final minMaxLenghtMessage = "$minLength文字以上、$maxLength文字以下で入力して下さい。";

    if (value == null) {
      final validation =
          Validation.create(isValid: true, message: defaultMessage);

      return validation;
    }

    if (value.isEmpty) {
      final validation =
          Validation.create(isValid: false, message: emptyMessage);
      return validation;
    }

    if (value.length < minLength) {
      final validation =
          Validation.create(isValid: false, message: minMaxLenghtMessage);
      return validation;
    }

    final validation =
        Validation.create(isValid: true, message: defaultMessage);

    return validation;
  }

  return minMaxLenghtValidator;
});
