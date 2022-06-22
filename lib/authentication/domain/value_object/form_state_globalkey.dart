import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'form_state_globalkey.freezed.dart';

@freezed
class FormStateGlobalKey with _$FormStateGlobalKey {
  // @Assert('value.length < 20')
  const factory FormStateGlobalKey(
    GlobalKey<FormState> value,
  ) = _FormStateGlobalKey;
}

class FormStateGlobalKeyConverter
    implements JsonConverter<FormStateGlobalKey, String> {
  const FormStateGlobalKeyConverter();

  @override
  FormStateGlobalKey fromJson(String json) {
    return FormStateGlobalKey(GlobalKey<FormState>());
  }

  @override
  String toJson(FormStateGlobalKey object) {
    return object.value.toString();
  }
}
