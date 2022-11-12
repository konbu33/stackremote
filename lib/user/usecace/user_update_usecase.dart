import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';

import '../../authentication/authentication.dart';
import '../../common/common.dart';
import '../../rtc_video/rtc_video.dart';

final userUpdateUsecaseProvider = Provider((ref) {
  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);

  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Future<void> execute<T>({
    String? email,
    String? nickName,
    String? comment,
    bool? isHost,
    T? joinedAt,
    T? leavedAt,
    // Timestamp? joinedAt,
    // Timestamp? leavedAt,
    bool? isOnLongPressing,
    Offset? pointerPosition,
  }) async {
    final Map<String, dynamic> data = {};

    if (email != null) data.addAll({...data, "email": email});

    if (nickName != null) data.addAll({...data, "nickName": nickName});

    if (comment != null) data.addAll({...data, "comment": comment});

    if (isHost != null) data.addAll({...data, "isHost": isHost});

    if (joinedAt != null) data.addAll({...data, "joinedAt": joinedAt});

    if (leavedAt != null) data.addAll({...data, "leavedAt": leavedAt});

    if (isOnLongPressing != null) {
      data.addAll({...data, "isOnLongPressing": isOnLongPressing});
    }

    if (pointerPosition != null) {
      data.addAll(
        {
          ...data,
          "pointerPosition": const OffsetConverter().toJson(pointerPosition),
        },
      );
    }

    userRepository.update(
      channelName: rtcChannelState.channelName,
      email: firebaseAuthUser.email,
      data: data,
    );
  }

  return execute;
});
