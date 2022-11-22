import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../../user/user.dart';

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

  logger.d("pointerStateList - $pointerStateList");

  return PointerStateListStateNotifier(pointerStateList: pointerStateList);
});

// --------------------------------------------------
//
// Get PointerState from userStreamList
//
// --------------------------------------------------

final pointerStateProvider = Provider((ref) {
  final usersState = ref.watch(usersStateNotifierProvider);

  final pointerStateList = usersState.users.map((user) {
    PointerState userToPointerState(User user) {
      final pointerState = PointerState.reconstruct(
        comment: user.comment,
        email: user.email,
        isOnLongPressing: user.isOnLongPressing,
        nickName: user.nickName,
        pointerPosition: user.pointerPosition,
        displayPointerPosition: user.displayPointerPosition,
      );

      return pointerState;
    }

    final pointerStateList = userToPointerState(user);
    return pointerStateList;
  }).toList();

  return pointerStateList;
});
