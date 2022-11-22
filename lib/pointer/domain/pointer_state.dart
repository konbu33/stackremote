import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../../user/user.dart';

part 'pointer_state.freezed.dart';
part 'pointer_state.g.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
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

  void updateIsOnLongPressing(bool isOnLongPressing) {
    state = state.copyWith(isOnLongPressing: isOnLongPressing);
  }

  void updatePointerPosition(Offset pointerPosition) {
    final displayPointerPosition = calcDisplayPointerPosition(pointerPosition);

    state = state.copyWith(
      pointerPosition: pointerPosition,
      displayPointerPosition: displayPointerPosition,
    );
  }

  Offset calcDisplayPointerPosition(Offset pointerPosition) {
    // Offset(0, 0)の場合、計算ぜすにreturn
    if (pointerPosition == const Offset(0, 0)) {
      return pointerPosition;
    }

    // Pointerが指に被るため、ずらす
    final adjustmentPointerPosition = Offset(
      pointerPosition.dx - 55,
      pointerPosition.dy + 5,
    );

    // 0以下の位置は0とする
    final lowerLimitPointerPosition = Offset(
      adjustmentPointerPosition.dx < 0 ? 0 : adjustmentPointerPosition.dx,
      adjustmentPointerPosition.dy < 0 ? 0 : adjustmentPointerPosition.dy,
    );

    return lowerLimitPointerPosition;
  }
}

// --------------------------------------------------
//
// PointerStateNotifierProvider
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

// --------------------------------------------------
//
// updateUserIsOnLongPressingProvider
//
// --------------------------------------------------
final updateUserIsOnLongPressingProvider = Provider.autoDispose((ref) async {
  final isOnLongPressing = ref.watch(
      pointerStateNotifierProvider.select((value) => value.isOnLongPressing));

  final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

  await userUpdateUsecase(
    isOnLongPressing: isOnLongPressing,
  );
});

// --------------------------------------------------
//
// updateUserPointerPositionProvider
//
// --------------------------------------------------
final updateUserPointerPositionProvider = Provider.autoDispose((ref) async {
  final pointerPosition = ref.watch(
      pointerStateNotifierProvider.select((value) => value.pointerPosition));

  final displayPointerPosition = ref.watch(pointerStateNotifierProvider
      .select((value) => value.displayPointerPosition));

  final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

  await userUpdateUsecase(
    pointerPosition: pointerPosition,
    displayPointerPosition: displayPointerPosition,
  );
});
