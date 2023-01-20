import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/rtc_video_state.dart';
import '../infrastructure/rtc_video_repository.dart';
import '../infrastructure/rtc_video_repository_agora.dart';

final muteLocalAudioStreamUsecaseProvider = Provider((ref) {
  Future<void> execute() async {
    final rtcVideoRepositoryAgoraCreator =
        ref.watch(rtcVideoRepositoryAgoraCreatorProvider);

    final RtcVideoRepository rtcVideoRepository =
        await rtcVideoRepositoryAgoraCreator();

    final isMuteAudioLocal = ref.watch(RtcVideoState.isMuteAudioLocalProvider);

    await rtcVideoRepository.muteLocalAudio(isMuteAudioLocal);
  }

  return execute;
});
