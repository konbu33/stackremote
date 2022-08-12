import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'password.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class Password with _$Password {
  const factory Password._({
    required String value,
    // @Default(8) int minLength,
    // @Default(20) int maxLength,
  }) = _Password;

  factory Password.create({
    required String value,
  }) =>
      Password._(value: value);
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class PasswordState extends StateNotifier<Password> {
  PasswordState({
    required String value,
  }) : super(
          Password.create(value: value),
        );

  bool isMaxLenght() {
    const int maxLength = 20;
    if (state.value.length > maxLength) return false;
    return true;
  }

  bool isMinLenght() {
    const int minLength = 8;
    if (state.value.length < minLength) return false;
    return true;
  }
}
