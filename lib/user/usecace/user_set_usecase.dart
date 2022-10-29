import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/authentication.dart';
import '../../rtc_video/rtc_video.dart';

import '../domain/user.dart';

final userSetUsecaseProvider = Provider((ref) {
  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);

  Future<void> execute({
    required String email,
    required String nickName,
    required bool isHost,
    Timestamp? joinedAt,
    Timestamp? leavedAt,
    bool? isOnLongPressing,
    Offset? pointerPosition,
  }) async {
    final User user = User.create(
      email: email,
      nickName: nickName,
      isHost: isHost,
      joinedAt: joinedAt,
      leavedAt: leavedAt,
      isOnLongPressing: isOnLongPressing ?? false,
      pointerPosition: pointerPosition ?? const Offset(0, 0),
    );

    await FirebaseFirestore.instance
        .collection('channels')
        .doc(rtcChannelState.channelName)
        .collection('users')
        .doc(firebaseAuthUser.email)
        .set({...user.toJson(), "joinedAt": FieldValue.serverTimestamp()});
  }

  return execute;
});
