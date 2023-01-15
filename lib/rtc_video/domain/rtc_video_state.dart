import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/rtc_video/usecase/switch_camera.dart';
import 'package:ulid/ulid.dart';

import '../../common/common.dart';

class RtcVideoState {
  static final rtcIdTokenProvider = StateProvider((ref) => "");

  static final account = Ulid().toString();

  static final isJoinedChannelProvider = StateProvider((ref) => false);

  static final localUid = Random().nextInt(232 - 1);

  static const privilegeExpireTime = 4000;

  static final remoteUidProvider = StateProvider((ref) => 1);

  static const role = "publisher";

  static const rtcIdTokenType = "uid";

  static final isMuteAudioLocalProvider = StateProvider((ref) => false);
  static final isMuteVideoLocalProvider = StateProvider((ref) => true);
  static final isUseOutSideCameraProvider = StateProvider((ref) => true);
}

// --------------------------------------------------
//
// reflectRtcVideoStateIsUserOutSideCameraProvider
//
// --------------------------------------------------
// autoDispose指定すると、チャンネル参加時に毎回実行されるため、autoDispose未指定とする。
final reflectRtcVideoStateIsUserOutSideCameraProvider = Provider(
  (ref) async {
    //

    final isUseOutSideCamera =
        ref.watch(RtcVideoState.isUseOutSideCameraProvider);

    logger.d("reflect: $isUseOutSideCamera");

    final switchCameraUsecase = ref.read(switchCameraUsecaseProvider);

    await switchCameraUsecase();
  },
);
