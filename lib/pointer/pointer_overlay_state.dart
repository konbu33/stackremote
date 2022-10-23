import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'pointer_overlay_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class PointerOerlayerState with _$PointerOerlayerState {
  const factory PointerOerlayerState._({
    required String name,
    required Offset pointerPosition,
    required Offset displayPointerPosition,
    // ignore: unused_element
    @Default(false) bool isOnLongPressing,
    required TextEditingController commentController,
  }) = _PointerOerlayerState;

  factory PointerOerlayerState.create() => PointerOerlayerState._(
        name: "鈴木直樹",
        pointerPosition: const Offset(0, 0),
        displayPointerPosition: const Offset(0, 0),
        commentController: TextEditingController(text: ""),
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class PointerOverlayStateNotifier extends StateNotifier<PointerOerlayerState> {
  PointerOverlayStateNotifier() : super(PointerOerlayerState.create());

  void updatePosition(Offset pointerPosition) {
    // 0以下の位置は0とする
    final Offset newPointerPosition = Offset(
      pointerPosition.dx < 0 ? 0 : pointerPosition.dx,
      pointerPosition.dy < 0 ? 0 : pointerPosition.dy,
    );

    final displayPointerPosition =
        calcDisplayPointerPosition(newPointerPosition);

    state = state.copyWith(
      pointerPosition: newPointerPosition,
      displayPointerPosition: displayPointerPosition,
    );
  }

  void changeOnLongPress({required bool isOnLongPressing}) {
    state = state.copyWith(isOnLongPressing: isOnLongPressing);
  }

  Offset calcDisplayPointerPosition(Offset pointerPosition) {
    // Pointerが指に被るため、ずらす
    return Offset(
      pointerPosition.dx - 55,
      pointerPosition.dy + 5,
    );
  }
}

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------
final pointerOverlayStateNotifierProvider =
    StateNotifierProvider<PointerOverlayStateNotifier, PointerOerlayerState>(
        (ref) => PointerOverlayStateNotifier());
