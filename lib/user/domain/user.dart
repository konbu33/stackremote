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
//   User
//
// --------------------------------------------------
@freezed
class User with _$User {
  const factory User._({
    @Default("") String comment,
    required String email,
    @Default(true) bool isHost,
    @Default(false) bool isOnLongPressing,
    @Default(null) @FirestoreTimestampConverter() Timestamp? joinedAt,
    @Default(null) @FirestoreTimestampConverter() Timestamp? leavedAt,
    @Default("") String nickName,
    @Default(Offset(0, 0)) @OffsetConverter() Offset pointerPosition,
    @Default(Offset(0, 0)) @OffsetConverter() Offset displayPointerPosition,
  }) = _User;

  factory User.create({
    required String email,
    String? nickName,
  }) =>
      User._(
        email: email,
        nickName: nickName ?? "",
      );

  factory User.reconstruct({
    String? comment,
    String? email,
    bool? isHost,
    bool? isOnLongPressing,
    Timestamp? joinedAt,
    Timestamp? leavedAt,
    String? nickName,
    Offset? pointerPosition,
    Offset? displayPointerPosition,
  }) =>
      User._(
        comment: comment ?? "",
        email: email ?? "",
        isHost: isHost ?? true,
        isOnLongPressing: isOnLongPressing ?? false,
        joinedAt: joinedAt,
        leavedAt: leavedAt,
        nickName: nickName ?? "",
        pointerPosition: pointerPosition ?? const Offset(0, 0),
        displayPointerPosition: displayPointerPosition ?? const Offset(0, 0),
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// --------------------------------------------------
//
//  UserStateNotifier
//
// --------------------------------------------------
class UserStateNotifier extends Notifier<User> {
  @override
  User build() {
    final email = ref.watch(
        firebaseAuthUserStateNotifierProvider.select((value) => value.email));

    String initialSetNickName(String newNickName) {
      String nickName = newNickName;

      const lengthLimit = 8;
      if (nickName.length > lengthLimit) {
        nickName = nickName.substring(0, lengthLimit);
        nickName += "...";
      }

      return nickName;
    }

    final nickName = initialSetNickName(email.split("@")[0]);

    final user = User.create(email: email, nickName: nickName);

    // build関数で初期化処理を行いたい場合、return + stateへの代入が必要な様子。
    // build関数で初期化処理を行いたいケースは無いかもしれない。
    state = user;

    return user;
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
//  userStateNotifierProvider
//
// --------------------------------------------------
final userStateNotifierProvider =
    NotifierProvider<UserStateNotifier, User>(() => UserStateNotifier());
