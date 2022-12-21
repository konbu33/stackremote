import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/authentication.dart';
import '../../channel/channel.dart';
import '../../common/common.dart';
import '../../pointer/domain/pointer_state.dart';
import '../../rtc_video/rtc_video.dart';
import '../user.dart';

part 'user.freezed.dart';
part 'user.g.dart';

final nickNameCreatorProvider = Provider((ref) {
  //
  String nickNameCreator(String newNickName) {
    String nickName = newNickName;

    const lengthLimit = 8;
    if (nickName.length > lengthLimit) {
      nickName = nickName.substring(0, lengthLimit);
      nickName += "...";
    }

    return nickName;
  }

  return nickNameCreator;
});

final nickNameProvider = StateProvider((ref) {
  //

  final email = ref.watch(
      firebaseAuthUserStateNotifierProvider.select((value) => value.email));

  final nickNameCreator = ref.watch(nickNameCreatorProvider);

  return nickNameCreator(email.split("@")[0]);
});

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
    required int rtcVideoUid,
  }) = _User;

  factory User.create({
    required String email,
    String? nickName,
    int? rtcVideoUid,
  }) =>
      User._(
        email: email,
        nickName: nickName ?? "",
        rtcVideoUid: rtcVideoUid ?? 0,
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
    int? rtcVideoUid,
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
        rtcVideoUid: rtcVideoUid ?? 0,
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// --------------------------------------------------
//
//  UserStateNotifier
//
// --------------------------------------------------
class UserStateNotifier extends AutoDisposeNotifier<User> {
  @override
  User build() {
    final comment = ref
        .watch(pointerStateNotifierProvider.select((value) => value.comment));

    final email = ref.watch(
        firebaseAuthUserStateNotifierProvider.select((value) => value.email));

    final hostUserEmail = ref.watch(
        channelStateNotifierProvider.select((value) => value.hostUserEmail));

    final isHost = email == hostUserEmail;

    final isOnLongPressing = ref.watch(
        pointerStateNotifierProvider.select((value) => value.isOnLongPressing));

    final nickName = ref.watch(nickNameProvider);

    final pointerPosition = ref.watch(
        pointerStateNotifierProvider.select((value) => value.pointerPosition));

    final displayPointerPosition = ref.watch(pointerStateNotifierProvider
        .select((value) => value.displayPointerPosition));

    final rtcVideoUid = RtcVideoState.localUid;

    final user = User.reconstruct(
      comment: comment,
      email: email,
      isHost: isHost,
      isOnLongPressing: isOnLongPressing,
      nickName: nickName,
      pointerPosition: pointerPosition,
      displayPointerPosition: displayPointerPosition,
      rtcVideoUid: rtcVideoUid,
    );

    return user;
  }
}

// --------------------------------------------------
//
//  userStateNotifierProvider
//
// --------------------------------------------------
final userStateNotifierProvider =
    AutoDisposeNotifierProvider<UserStateNotifier, User>(
        () => UserStateNotifier());

// --------------------------------------------------
//
// updateUserCommentProvider
//
// --------------------------------------------------
final updateUserCommentProvider = Provider.autoDispose((ref) async {
  final comment =
      ref.watch(userStateNotifierProvider.select((value) => value.comment));

  final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

  await userUpdateUsecase(
    comment: comment,
  );
});

// --------------------------------------------------
//
// updateUserIsOnLongPressingProvider
//
// --------------------------------------------------
final updateUserIsOnLongPressingProvider = Provider.autoDispose((ref) async {
  final isOnLongPressing = ref.watch(
      userStateNotifierProvider.select((value) => value.isOnLongPressing));

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
      userStateNotifierProvider.select((value) => value.pointerPosition));

  final displayPointerPosition = ref.watch(userStateNotifierProvider
      .select((value) => value.displayPointerPosition));

  final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);

  await userUpdateUsecase(
    pointerPosition: pointerPosition,
    displayPointerPosition: displayPointerPosition,
  );
});
