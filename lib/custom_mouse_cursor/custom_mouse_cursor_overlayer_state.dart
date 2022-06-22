import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'custom_mouse_cursor_overlayer_state.freezed.dart';

@freezed
class CustomMouseCursorOerlayerState with _$CustomMouseCursorOerlayerState {
  const factory CustomMouseCursorOerlayerState({
    required String name,
    required Offset cursorPosition,
    @Default(false) bool isOnLongPressing,
    // required double positionDx,
    // required double positionDy,
  }) = _CustomMouseCursorOerlayerState;

  factory CustomMouseCursorOerlayerState.initial() =>
      const CustomMouseCursorOerlayerState(
        name: "Custom Mouse",
        cursorPosition: Offset(30, 10),
        // positionDx: 10.0,
        // positionDy: 30.0,
      );
}
