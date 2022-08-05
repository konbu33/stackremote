import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'login_text_editing_controller.freezed.dart';

@freezed
class LoginTextEditingController with _$LoginTextEditingController {
  const factory LoginTextEditingController({
    required TextEditingController value,
  }) = _LoginTextEditingController;
}

class LoginTextEditingControllerConverter
    implements JsonConverter<LoginTextEditingController, String> {
  const LoginTextEditingControllerConverter();

  @override
  LoginTextEditingController fromJson(String json) {
    return LoginTextEditingController(value: TextEditingController());
  }

  @override
  String toJson(LoginTextEditingController object) {
    return object.value.text;
  }
}
