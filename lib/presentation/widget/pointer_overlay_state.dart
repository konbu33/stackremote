import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
  const factory PointerOerlayerState({
    required String name,
    required Offset pointerPosition,
    @Default(false) bool isOnLongPressing,
  }) = _PointerOerlayerState;

  factory PointerOerlayerState.initial() => const PointerOerlayerState(
        name: "Custom Mouse",
        pointerPosition: Offset(30, 10),
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class PointerOverlayStateNotifier extends StateNotifier<PointerOerlayerState> {
  PointerOverlayStateNotifier() : super(PointerOerlayerState.initial());

  void updatePosition(Offset offset) {
    state = state.copyWith(pointerPosition: offset);
  }

  void changeOnLongPress({required bool isOnLongPressing}) {
    state = state.copyWith(isOnLongPressing: isOnLongPressing);
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
