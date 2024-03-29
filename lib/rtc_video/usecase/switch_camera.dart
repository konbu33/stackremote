import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infrastructure/rtc_video_repository.dart';
import '../infrastructure/rtc_video_repository_agora.dart';

final switchCameraUsecaseProvider = Provider((ref) {
  Future<void> execute() async {
    final rtcVideoRepositoryAgoraCreator =
        ref.watch(rtcVideoRepositoryAgoraCreatorProvider);

    final RtcVideoRepository rtcVideoRepository =
        await rtcVideoRepositoryAgoraCreator();

    await rtcVideoRepository.switchCamera();
  }

  return execute;
});
