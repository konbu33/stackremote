import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ulid/ulid.dart';

class RtcVideoState {
  static final rtcIdTokenProvider = StateProvider((ref) => "");

  static final account = Ulid().toString();

  static final isJoinedChannelProvider = StateProvider((ref) => false);

  static final localUid = Random().nextInt(232 - 1);

  static const privilegeExpireTime = 4000;

  static final remoteUidProvider = StateProvider((ref) => 1);

  static const role = "publisher";

  static const rtcIdTokenType = "uid";
}
