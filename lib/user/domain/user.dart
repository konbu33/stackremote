import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/domain/users.dart';

import '../../common/common.dart';
import '../usecace/user_fetch_by_id_usecase.dart';

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
    required String nickName,
    required String comment,
    required bool isHost,
    @FirestoreTimestampConverter() required Timestamp? joinedAt,
    @FirestoreTimestampConverter() required Timestamp? leavedAt,
    required bool isOnLongPressing,
    @OffsetConverter() required Offset pointerPosition,
  }) = _User;

  factory User.create({
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
        isHost: isHost ?? false,
        joinedAt: joinedAt,
        leavedAt: leavedAt,
        isOnLongPressing: isOnLongPressing ?? false,
        pointerPosition: pointerPosition ?? const Offset(0, 0),
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
        isHost: isHost ?? false,
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
  UserStateNotifier() : super(User.create()) {
    initial();
  }

  void initial() {
    state = User.create();
  }

  void setNickName(String nickName) {
    state = state.copyWith(nickName: nickName);
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final userStateNotifierProvider =
    StateNotifierProvider<UserStateNotifier, User>(
  (ref) => UserStateNotifier(),
);

// --------------------------------------------------
//
// StreamProvider
//
// --------------------------------------------------
final userStreamProviderFamily =
    StreamProvider.family<User, String>((ref, email) {
  final userStream = ref.watch(userFetchByIdUsecaseProvider);
  return userStream(email: email);
});

// --------------------------------------------------
//
// Provider
//
// --------------------------------------------------
final userStreamListProvider = Provider<List<AsyncValue<User>>?>((ref) {
// final usersStreamProvider = StreamProvider<QuerySnapshot>((ref) {
  final usersStream = ref.watch(usersStreamProvider);
  // final userStream = ref.watch(userFetchByIdUsecaseProvider);

  final userStreamList =
      usersStream.when<List<AsyncValue<User>>?>(data: ((data) {
    return data.users.map((user) {
      final userStream = ref.watch(userStreamProviderFamily(user.email));
      return userStream;
    }).toList();
  }), error: ((error, stackTrace) {
    return null;
  }), loading: (() {
    return null;
  }));

  // final rtcChannelState = ref.watch(
  //     RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  // return FirebaseFirestore.instance
  //     .collection('channels')
  //     .doc(rtcChannelState.channelName)
  //     .collection('users')
  //     .snapshots();

  return userStreamList;
});
