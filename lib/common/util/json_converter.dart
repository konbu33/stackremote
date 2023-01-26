import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../user/user.dart';

// --------------------------------------------------
//
//  OffsetConverter
//
// --------------------------------------------------
class OffsetConverter extends JsonConverter<Offset, String> {
  const OffsetConverter();

  @override
  String toJson(Offset object) {
    final double dx = object.dx;
    final double dy = object.dy;
    final Map<String, double> jsonMap = {
      "dx": dx,
      "dy": dy,
    };
    return jsonEncode(jsonMap);
  }

  @override
  Offset fromJson(String json) {
    final Map<String, dynamic> jsonMap = jsonDecode(json);
    final double dx = jsonMap["dx"];
    final double dy = jsonMap["dy"];

    return Offset(dx, dy);
  }
}

// --------------------------------------------------
//
//  TextEditingControllerConverter
//
// --------------------------------------------------
class TextEditingControllerConverter
    extends JsonConverter<TextEditingController, String> {
  const TextEditingControllerConverter();

  @override
  String toJson(TextEditingController object) {
    return object.text;
  }

  @override
  TextEditingController fromJson(String json) {
    return TextEditingController(text: json);
  }
}

// --------------------------------------------------
//
//  FocusNodeConverter
//
// --------------------------------------------------
class FocusNodeConverter extends JsonConverter<FocusNode, String> {
  const FocusNodeConverter();

  @override
  String toJson(FocusNode object) {
    return object.toString();
  }

  @override
  FocusNode fromJson(String json) {
    return FocusNode();
  }
}

// --------------------------------------------------
//
//  SizeConverter
//
// --------------------------------------------------
class SizeConverter extends JsonConverter<Size, String> {
  const SizeConverter();

  @override
  String toJson(Size object) {
    final double width = object.width;
    final double height = object.height;
    final Map<String, double> jsonMap = {
      "width": width,
      "height": height,
    };
    return jsonEncode(jsonMap);
  }

  @override
  Size fromJson(String json) {
    final Map<String, dynamic> jsonMap = jsonDecode(json);
    final double width = jsonMap["width"];
    final double height = jsonMap["height"];

    return Size(width, height);
  }
}

// --------------------------------------------------
//
//  DateTimeConverter
//
// --------------------------------------------------
class DateTimeConverter extends JsonConverter<DateTime?, String?> {
  const DateTimeConverter();

  @override
  String? toJson(DateTime? object) {
    if (object == null) return null;

    return object.toString();
  }

  @override
  DateTime? fromJson(String? json) {
    if (json == null) return null;

    return DateTime.parse(json);
  }
}

// --------------------------------------------------
//
//  UserColorConverter
//
// --------------------------------------------------
class UserColorConverter extends JsonConverter<UserColor, String> {
  const UserColorConverter();

  @override
  String toJson(UserColor object) {
    return object.toString();
  }

  @override
  UserColor fromJson(String json) {
    return UserColor.fromJson(json);
  }
}
