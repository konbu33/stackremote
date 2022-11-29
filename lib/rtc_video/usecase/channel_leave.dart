import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infrastructure/rtc_video_repository.dart';
import '../infrastructure/rtc_video_repository_agora.dart';

final channelLeaveUsecaseProvider = Provider((ref) async {
  final RtcVideoRepository rtcVideoRepository =
      await ref.watch(rtcVideoRepositoryAgoraProvider);

  Future<void> execute() async {
    await rtcVideoRepository.channelLeave();
  }

  return execute;
});
