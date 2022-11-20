import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../common/common.dart';
import 'pointer_provider.dart';
import 'pointer_state.dart';

part 'pointer_state_list.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class PointerStateList with _$PointerStateList {
  const factory PointerStateList._({
    required List<PointerState> pointerStateList,
  }) = _PointerOerlayerState;

  factory PointerStateList.create({
    required List<PointerState> pointerStateList,
  }) =>
      PointerStateList._(
        pointerStateList: pointerStateList,
      );

  factory PointerStateList.reconstruct({
    List<PointerState>? pointerStateList,
  }) =>
      PointerStateList._(
        pointerStateList: pointerStateList ?? [PointerState.create(email: "")],
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class PointerStateListStateNotifier extends StateNotifier<PointerStateList> {
  PointerStateListStateNotifier({
    required List<PointerState> pointerStateList,
  }) : super(PointerStateList.create(
          pointerStateList: pointerStateList,
        ));
}

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------
final pointerStateListStateNotifierProvider =
    StateNotifierProvider<PointerStateListStateNotifier, PointerStateList>(
        (ref) {
  final pointerStateList = ref.watch(pointerStateProvider);

  List<PointerState> newPointerStateList = [];

  if (pointerStateList.isNotEmpty) {
    newPointerStateList = pointerStateList as List<PointerState>;
  }

  return PointerStateListStateNotifier(pointerStateList: newPointerStateList);
});
