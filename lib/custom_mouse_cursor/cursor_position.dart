// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'cursor_position.freezed.dart';
// part 'cursor_position.g.dart';

@freezed
class CursorPosition with _$CursorPosition {
  const factory CursorPosition._({
    required Offset value,
    // required int dx,
    // required int dy,
  }) = _CursorPosition;

  factory CursorPosition.initial({
    Offset? value,
  }) =>
      CursorPosition._(
        value: value ?? Offset(0, 0),
        // dx: 0,
        // dy: 0,
      );

  // factory CursorPosition.fromJson(Map<String, dynamic> json) =>
  // CursorPosition.fromJson(json);
}

class CursorPositionConverter extends JsonConverter<CursorPosition, String> {
  const CursorPositionConverter();

  @override
  CursorPosition fromJson(String json) {
    // final Map<String, dynamic> jsonObject = jsonDecode(json);
    // print("jsonObject--------------------  : $jsonObject");

    return CursorPosition._(value: Offset(0, 0));
  }

  @override
  String toJson(CursorPosition object) {
    return "{dx: ${object.value.dx}, dy: ${object.value.dy}}";
  }
}
