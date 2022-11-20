// import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/user.dart';

import '../common/common.dart';

part 'pointer_state.freezed.dart';
part 'pointer_state.g.dart';

@freezed
class PointerState with _$PointerState {
  const factory PointerState._({
    @Default("") String comment,
    required String email,
    @Default(false) bool isOnLongPressing,
    @Default("") String nickName,
    @Default(Offset(0, 0)) @OffsetConverter() Offset pointerPosition,
    @Default(Offset(0, 0)) @OffsetConverter() Offset displayPointerPosition,
  }) = _PointerState;

  factory PointerState.create({
    required String email,
    String? nickName,
  }) =>
      PointerState._(
        email: email,
        nickName: nickName ?? "",
      );

  factory PointerState.reconstruct({
    String? comment,
    String? email,
    bool? isOnLongPressing,
    String? nickName,
    Offset? pointerPosition,
    Offset? displayPointerPosition,
  }) =>
      PointerState._(
        comment: comment ?? "",
        email: email ?? "",
        isOnLongPressing: isOnLongPressing ?? false,
        nickName: nickName ?? "",
        pointerPosition: pointerPosition ?? const Offset(0, 0),
        displayPointerPosition: displayPointerPosition ?? const Offset(0, 0),
      );

  factory PointerState.fromJson(Map<String, dynamic> json) =>
      _$PointerStateFromJson(json);
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class PointerStateNotifier extends StateNotifier<PointerState> {
  PointerStateNotifier({
    required String email,
    String? nickName,
  }) : super(PointerState.create(email: email, nickName: nickName));

  Offset calcDisplayPointerPosition(Offset pointerPosition) {
    // Pointerが指に被るため、ずらす
    return Offset(
      pointerPosition.dx - 55,
      pointerPosition.dy + 5,
    );
  }

  void updatePosition(Offset pointerPosition) {
    // 0以下の位置は0とする
    final Offset newPointerPosition = Offset(
      pointerPosition.dx < 0 ? 0 : pointerPosition.dx,
      pointerPosition.dy < 0 ? 0 : pointerPosition.dy,
    );

    final displayPointerPosition =
        calcDisplayPointerPosition(newPointerPosition);

    state = state.copyWith(
      displayPointerPosition: displayPointerPosition,
    );
  }
}

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------
final pointerStateNotifierProvider =
    StateNotifierProvider.autoDispose<PointerStateNotifier, PointerState>(
        (ref) {
  final userState = ref.watch(userStateNotifierProvider);
  return PointerStateNotifier(
    email: userState.email,
    nickName: userState.nickName,
  );
});
