import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';

import '../domain/user.dart';
import '../domain/user_repository.dart';
import '../infrastructure/user_repository_firestore.dart';

final userUpdateUsecaseProvider = Provider.autoDispose((ref) {
  final userStateEmail =
      ref.watch(userStateNotifierProvider.select((value) => value.email));

  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Future<void> execute({
    String? comment,
    String? email,
    bool? isHost,
    bool? isOnLongPressing,
    bool? isJoinedAt,
    bool? isLeavedAt,
    String? nickName,
    Offset? pointerPosition,
    Offset? displayPointerPosition,
    int? rtcVideoUid,
    Size? displaySizeVideoMain,
    UserColor? userColor,
    bool? isMuteVideo,
  }) async {
    final Map<String, dynamic> data = {};

    if (comment != null) data.addAll({...data, "comment": comment});
    if (email != null) data.addAll({...data, "email": email});

    if (isHost != null) data.addAll({...data, "isHost": isHost});
    if (isOnLongPressing != null) {
      data.addAll({...data, "isOnLongPressing": isOnLongPressing});
    }

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

    if (userColor != null) {
      data.addAll({...data, "userColor": userColor.toString()});
    }

    if (isMuteVideo != null) {
      data.addAll({...data, "isMuteVideo": isMuteVideo});
    }

    logger.d("userUpdateUsecase: $data");

    await userRepository.update(
      email: userStateEmail,
      data: data,
      isJoinedAt: isJoinedAt ?? false,
      isLeavedAt: isLeavedAt ?? false,
    );
  }

  return execute;
});
