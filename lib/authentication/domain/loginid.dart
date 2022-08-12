import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'loginid.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class LoginId with _$LoginId {
  const factory LoginId._({
    required String value,
    // @Default(8) int minLength,
    // @Default(20) int maxLength,
  }) = _LoginId;

  factory LoginId.create({
    required String value,
  }) =>
      LoginId._(value: value);
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class LoginIdState extends StateNotifier<LoginId> {
  LoginIdState({
    required String value,
  }) : super(
          LoginId.create(value: value),
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
