import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'validation.freezed.dart';

@freezed
class Validation with _$Validation {
  const factory Validation._({
    required bool isValid,
    @Default("") String message,
  }) = _Validation;

  factory Validation.create({
    bool? isValid,
    String? message,
  }) =>
      Validation._(
        isValid: isValid ?? false,
        message: message ?? "",
      );
}
