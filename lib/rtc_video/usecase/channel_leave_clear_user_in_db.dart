import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../user/user.dart';

final channelLeaveClearUserInDBUsecaseProvider = Provider((ref) {
  //

  Future<void> execute() async {
    final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);
    await userUpdateUsecase(
      comment: "",
      isLeavedAt: true,
      isOnLongPressing: false,
      pointerPosition: const Offset(0, 0),
      displayPointerPosition: const Offset(0, 0),
    );
  }

  return execute;
});
