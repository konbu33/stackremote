import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'form_field_state_globalkey.freezed.dart';

@freezed
class FormFieldStateGlobalKey with _$FormFieldStateGlobalKey {
  const factory FormFieldStateGlobalKey({
    required GlobalKey<FormFieldState> value,
  }) = _FormFieldStateGlobalKey;
}

class FormFieldStateGlobalKeyConverter
    implements JsonConverter<FormFieldStateGlobalKey, String> {
  const FormFieldStateGlobalKeyConverter();

  @override
  FormFieldStateGlobalKey fromJson(String json) {
    return FormFieldStateGlobalKey(value: GlobalKey<FormFieldState>());
  }

  @override
  String toJson(FormFieldStateGlobalKey object) {
    return object.value.toString();
  }
}
