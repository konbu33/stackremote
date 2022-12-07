import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../channel/channel.dart';

import '../domain/rtc_video_state.dart';
import '../infrastructure/rtc_video_repository.dart';
import '../infrastructure/rtc_video_repository_agora.dart';

final channelJoinUsecaseProvider = Provider((ref) {
  Future<void> execute() async {
    final rtcVideoRepositoryAgoraCreator =
        ref.watch(rtcVideoRepositoryAgoraCreatorProvider);

    final RtcVideoRepository rtcVideoRepository =
        await rtcVideoRepositoryAgoraCreator();

    final channelName = ref.watch(channelNameProvider);
    final rtcIdToken = ref.watch(RtcVideoState.rtcIdTokenProvider);

    await rtcVideoRepository.channelJoin(
      token: rtcIdToken,
      channelName: channelName,
      optionalInfo: null,
      optionalUid: RtcVideoState.localUid,
    );
  }

  return execute;
});
