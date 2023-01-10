import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../user/user.dart';

import 'pointer_state.dart';

part 'pointer_state_list.freezed.dart';

// --------------------------------------------------
//
// PointerStateList
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
// PointerStateListStateNotifier
//
// --------------------------------------------------
class PointerStateListStateNotifier extends Notifier<PointerStateList> {
  @override
  PointerStateList build() {
    final userStateList =
        ref.watch(usersStateNotifierProvider.select((value) => value.users));

    if (userStateList.isEmpty) {
      return PointerStateList.create(pointerStateList: []);
    }

    final pointerStateList = userStateList.map((user) {
      //

      final pointerState = PointerState.reconstruct(
        comment: user.comment,
        email: user.email,
        isOnLongPressing: user.isOnLongPressing,
        nickName: user.nickName,
        pointerPosition: user.pointerPosition,
        displayPointerPosition: user.displayPointerPosition,
        userColor: user.userColor,
      );

      return pointerState;

      //
    }).toList();

    final newPointerStateList =
        PointerStateList.create(pointerStateList: pointerStateList);

    return newPointerStateList;
  }
}

// --------------------------------------------------
//
// pointerStateListStateNotifierProvider
//
// --------------------------------------------------
final pointerStateListStateNotifierProvider =
    NotifierProvider<PointerStateListStateNotifier, PointerStateList>(
        () => PointerStateListStateNotifier());
