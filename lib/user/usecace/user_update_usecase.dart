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
    String? email,
    String? nickName,
    String? comment,
    bool? isHost,
    // T は Timestamp or Timestamp を想定
    T? joinedAt,
    T? leavedAt,
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
      email: firebaseAuthUser.email,
      data: data,
    );
  }

  return execute;
});
