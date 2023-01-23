import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infrastructure/rtc_video_repository.dart';
import '../infrastructure/rtc_video_repository_agora.dart';

final setVideoEncoderConfigurationUsecaseProvider = Provider((ref) {
  Future<void> execute(Size videoDimensions) async {
    final rtcVideoRepositoryAgoraCreator =
        ref.watch(rtcVideoRepositoryAgoraCreatorProvider);

    final RtcVideoRepository rtcVideoRepository =
        await rtcVideoRepositoryAgoraCreator();

    await rtcVideoRepository.setVideoEncoderConfiguration(videoDimensions);
  }

  return execute;
});
