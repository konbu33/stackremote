import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/authentication.dart';
import '../../common/common.dart';

import '../domain/user_repository.dart';
import '../infrastructure/user_repository_firestore.dart';

final userUpdateUsecaseProvider = Provider((ref) {
  final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);

  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Future<void> execute<T>({
    String? comment,
    String? email,
    bool? isHost,
    bool? isOnLongPressing,
    // T は Timestamp or Timestamp を想定
    T? joinedAt,
    T? leavedAt,
    String? nickName,
    Offset? pointerPosition,
    Offset? displayPointerPosition,
    int? rtcVideoUid,
    Size? displaySizeVideoMain,
  }) async {
    final Map<String, dynamic> data = {};

    if (comment != null) data.addAll({...data, "comment": comment});
    if (email != null) data.addAll({...data, "email": email});

    if (isHost != null) data.addAll({...data, "isHost": isHost});
    if (isOnLongPressing != null) {
      data.addAll({...data, "isOnLongPressing": isOnLongPressing});
    }

    if (joinedAt != null) data.addAll({...data, "joinedAt": joinedAt});
    if (leavedAt != null) data.addAll({...data, "leavedAt": leavedAt});

    if (nickName != null) data.addAll({...data, "nickName": nickName});
    if (pointerPosition != null) {
      data.addAll(
        {
          ...data,
          "pointerPosition": const OffsetConverter().toJson(pointerPosition),
        },
      );
    }

    if (displayPointerPosition != null) {
      data.addAll(
        {
          ...data,
          "displayPointerPosition":
              const OffsetConverter().toJson(displayPointerPosition),
        },
      );
    }

    if (rtcVideoUid != null) data.addAll({...data, "rtcVideoUid": rtcVideoUid});

    if (displaySizeVideoMain != null) {
      data.addAll(
        {
          ...data,
          "displaySizeVideoMain":
              const SizeConverter().toJson(displaySizeVideoMain),
        },
      );
    }

    await userRepository.update(
      email: firebaseAuthUser.email,
      data: data,
    );
  }

  return execute;
});
