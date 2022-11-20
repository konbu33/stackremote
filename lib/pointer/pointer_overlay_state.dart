import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/common.dart';
// import 'pointer_provider.dart';
// import 'pointer_state.dart';

part 'pointer_overlay_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class PointerOerlayerState with _$PointerOerlayerState {
  const factory PointerOerlayerState._({
    @TextEditingControllerConverter()
        required TextEditingController commentController,
    @FocusNodeConverter() required FocusNode focusNode,
  }) = _PointerOerlayerState;

  factory PointerOerlayerState.create() => PointerOerlayerState._(
        commentController: TextEditingController(text: ""),
        focusNode: FocusNode(),
      );

  factory PointerOerlayerState.reconstruct() => PointerOerlayerState._(
        commentController: TextEditingController(text: ""),
        focusNode: FocusNode(),
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class PointerOverlayStateNotifier extends StateNotifier<PointerOerlayerState> {
  PointerOverlayStateNotifier() : super(PointerOerlayerState.create());
}

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------
final pointerOverlayStateNotifierProvider =
    StateNotifierProvider<PointerOverlayStateNotifier, PointerOerlayerState>(
        (ref) {
  return PointerOverlayStateNotifier();
});
