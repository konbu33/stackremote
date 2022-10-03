import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'email.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class Email with _$Email {
  const factory Email._({
    required String value,
    // @Default(8) int minLength,
    // @Default(20) int maxLength,
  }) = _Email;

  factory Email.create({
    required String value,
  }) =>
      Email._(value: value);
}

// --------------------------------------------------
//
//  JsonConverter
//
// --------------------------------------------------

// fromJson, toJsonメソッド利用可能にするためのコンバータ
class EmailConverter extends JsonConverter<Email, String> {
  const EmailConverter();

  @override
  Email fromJson(String json) {
    return Email._(value: json);
  }

  @override
  String toJson(Email object) {
    return object.value.toString();
  }
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class EmailState extends StateNotifier<Email> {
  EmailState({
    required String value,
  }) : super(
          Email.create(value: value),
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
