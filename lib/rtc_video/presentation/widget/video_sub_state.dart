import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../user/user.dart';

class VideoSubState {
  static final currentUidOfVideoMainProvider = StateProvider.autoDispose((ref) {
    final currentUid = ref
        .watch(userStateNotifierProvider.select((value) => value.rtcVideoUid));

    return currentUid;
  });

  static final videoSubLayerAlignmentProvider =
      StateProvider.autoDispose((ref) => AlignmentDirectional.topStart);
}
