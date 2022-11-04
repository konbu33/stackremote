import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/domain/user_repository.dart';

import '../../authentication/authentication.dart';
import '../../rtc_video/rtc_video.dart';

import '../domain/user.dart';
import '../infrastructure/user_repository_firestore.dart';

final userSetUsecaseProvider = Provider((ref) {
  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);

  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Future<void> execute({
    required String nickName,
    required bool isHost,
    Timestamp? joinedAt,
    Timestamp? leavedAt,
    bool? isOnLongPressing,
    Offset? pointerPosition,
  }) async {
    final User user = User.create(
      email: firebaseAuthUser.email,
      nickName: nickName,
      isHost: isHost,
      joinedAt: joinedAt,
      leavedAt: leavedAt,
      isOnLongPressing: isOnLongPressing ?? false,
      pointerPosition: pointerPosition ?? const Offset(0, 0),
    );

    await userRepository.set(
      channelName: rtcChannelState.channelName,
      email: user.email,
      user: user,
    );
  }

  return execute;
});
