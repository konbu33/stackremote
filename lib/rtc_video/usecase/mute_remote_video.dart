import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infrastructure/rtc_video_repository.dart';
import '../infrastructure/rtc_video_repository_agora.dart';

final muteRemoteVideoStreamUsecaseProvider = Provider((ref) {
  Future<void> execute({
    required int remoteUid,
    required bool isMute,
  }) async {
    final rtcVideoRepositoryAgoraCreator =
        ref.watch(rtcVideoRepositoryAgoraCreatorProvider);

    final RtcVideoRepository rtcVideoRepository =
        await rtcVideoRepositoryAgoraCreator();

    await rtcVideoRepository.muteRemoteVideo(
      remoteUid: remoteUid,
      isMute: isMute,
    );
  }

  return execute;
});
