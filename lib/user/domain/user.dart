import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/authentication.dart';
import '../../common/common.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class User with _$User {
  const factory User._({
    required String email,
    @Default("") String nickName,
    @Default("") String comment,
    @Default(true) bool isHost,
    @Default(null) @FirestoreTimestampConverter() Timestamp? joinedAt,
    @Default(null) @FirestoreTimestampConverter() Timestamp? leavedAt,
    @Default(false) bool isOnLongPressing,
    @Default(Offset(0, 0)) @OffsetConverter() Offset pointerPosition,
  }) = _User;

  factory User.create({
    required String email,
  }) =>
      User._(
        email: email,
      );

  factory User.reconstruct({
    String? email,
    String? nickName,
    String? comment,
    bool? isHost,
    Timestamp? joinedAt,
    Timestamp? leavedAt,
    bool? isOnLongPressing,
    Offset? pointerPosition,
  }) =>
      User._(
        email: email ?? "",
        nickName: nickName ?? "",
        comment: comment ?? "",
        isHost: isHost ?? true,
        joinedAt: joinedAt,
        leavedAt: leavedAt,
        isOnLongPressing: isOnLongPressing ?? false,
        pointerPosition: pointerPosition ?? const Offset(0, 0),
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class UserStateNotifier extends StateNotifier<User> {
  UserStateNotifier({
    required String email,
  }) : super(User.create(email: email)) {
    initial();
  }

  void initial() {
    setNickName(state.email.split("@")[0]);
  }

  void setNickName(String newNickName) {
    String nickName = newNickName;

    const lengthLimit = 8;
    if (nickName.length > lengthLimit) {
      nickName = nickName.substring(0, lengthLimit);
      nickName += "...";
    }

    state = state.copyWith(nickName: nickName);
  }

  void updateIsHost(bool isHost) {
    state = state.copyWith(isHost: isHost);
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final userStateNotifierProvider =
    StateNotifierProvider<UserStateNotifier, User>((ref) {
  final email = ref.watch(
      firebaseAuthUserStateNotifierProvider.select((value) => value.email));

  return UserStateNotifier(email: email);
});
