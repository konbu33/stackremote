import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/authentication.dart';
import '../../common/common.dart';
import '../../user/user.dart';

part 'pointer_state.freezed.dart';
part 'pointer_state.g.dart';

// --------------------------------------------------
//
// PointerState
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
    @Default(UserColor.red) @UserColorConverter() UserColor userColor,
  }) = _PointerState;

  factory PointerState.create({
    String? email,
    String? nickName,
  }) =>
      PointerState._(
        email: email ?? "",
        nickName: nickName ?? "",
      );

  factory PointerState.reconstruct({
    String? comment,
    String? email,
    bool? isOnLongPressing,
    String? nickName,
    Offset? pointerPosition,
    Offset? displayPointerPosition,
    UserColor? userColor,
  }) =>
      PointerState._(
        comment: comment ?? "",
        email: email ?? "",
        isOnLongPressing: isOnLongPressing ?? false,
        nickName: nickName ?? "",
        pointerPosition: pointerPosition ?? const Offset(0, 0),
        displayPointerPosition: displayPointerPosition ?? const Offset(0, 0),
        userColor: userColor ?? UserColor.red,
      );

  factory PointerState.fromJson(Map<String, dynamic> json) =>
      _$PointerStateFromJson(json);
}

// --------------------------------------------------
//
// PointerStateNotifier
//
// --------------------------------------------------
class PointerStateNotifier extends AutoDisposeNotifier<PointerState> {
  @override
  PointerState build() {
    final email = ref.watch(
        firebaseAuthUserStateNotifierProvider.select((value) => value.email));

    final nickName = ref.watch(NickName.nickNameProvider);

    final pointerState = PointerState.create(
      email: email,
      nickName: nickName,
    );

    logger.d("pointerState: $pointerState");
    return pointerState;
  }

  void updateComment(String comment) {
    state = state.copyWith(comment: comment);
  }

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
      pointerPosition.dx - 100,
      pointerPosition.dy - 100,
    );

    // 0以下の位置は0とする
    final lowerLimitPointerPosition = Offset(
      adjustmentPointerPosition.dx < 0 ? 0 : adjustmentPointerPosition.dx,
      adjustmentPointerPosition.dy < 0 ? 0 : adjustmentPointerPosition.dy,
    );

    return lowerLimitPointerPosition;
  }

  void updateUserColor(UserColor userColor) {
    logger.d("pointerState userColor: $userColor");
    state = state.copyWith(userColor: userColor);
  }
}

// --------------------------------------------------
//
// pointerStateNotifierProvider
//
// --------------------------------------------------
final pointerStateNotifierProvider =
    NotifierProvider.autoDispose<PointerStateNotifier, PointerState>(
        () => PointerStateNotifier());
