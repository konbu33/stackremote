import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'login_icon.freezed.dart';

@freezed
class LoginIcon with _$LoginIcon {
  const factory LoginIcon({
    required Icon value,
  }) = _LoginIcon;
}

class LoginIconConverter implements JsonConverter<LoginIcon, String> {
  const LoginIconConverter();

  @override
  LoginIcon fromJson(String json) {
    return const LoginIcon(value: Icon(Icons.mail));
  }

  @override
  String toJson(LoginIcon object) {
    return object.value.toString();
  }
}
