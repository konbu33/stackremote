import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// import 'custom_mouse_cursor/custom_mouse_cursor_overlayer_state.dart';
import 'userid.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class User with _$User {
  const factory User._({
    @UserIdConverter() required UserId userId,
    required String email,
    required String password,
    @OffsetConverter() required Offset cursorPosition,
    @Default(false) bool isOnLongPressing,
    // @CursorPositionConverter() required CursorPosition cursorPosition,
    // @CustomMouseCursorOerlayerStateConverter()
    //     required CustomMouseCursorOerlayerState customMouseCursorOerlayerState,
  }) = _User;

  factory User.create({
    required String email,
    required String password,
    Offset? cursorPosition,
    bool? isOnLongPressing,
  }) =>
      User._(
        userId: UserId.create(),
        email: email,
        password: password,
        cursorPosition: cursorPosition ?? const Offset(0, 0),
        isOnLongPressing: isOnLongPressing ?? false,
        // cursorPosition: CursorPosition.initial(),
        // customMouseCursorOerlayerState:
        //     CustomMouseCursorOerlayerState.initial(),
      );

  factory User.reconstruct({
    required UserId userId,
    required String email,
    required String password,
    Offset? cursorPosition,
    bool? isOnLongPressing,
    // required CustomMouseCursorOerlayerState customMouseCursorOerlayerState,
  }) =>
      User._(
        userId: userId,
        email: email,
        password: password,
        cursorPosition: cursorPosition ?? const Offset(0, 0),
        isOnLongPressing: isOnLongPressing ?? false,
        // cursorPosition: CursorPosition.initial(),
        // customMouseCursorOerlayerState:
        //     CustomMouseCursorOerlayerState.initial(),
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// --------------------------------------------------
//
//  JsonConverter
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
