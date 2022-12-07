import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../channel/channel.dart';

import '../domain/rtc_video_state.dart';
import '../infrastructure/rtc_video_repository.dart';
import '../infrastructure/rtc_video_repository_agora.dart';

final createRtcIdTokenUsecaseProvider = Provider((ref) {
  Future<String> execute() async {
    final rtcVideoRepositoryAgoraCreator =
        ref.watch(rtcVideoRepositoryAgoraCreatorProvider);

    final RtcVideoRepository rtcVideoRepository =
        await rtcVideoRepositoryAgoraCreator();

    final channelName = ref.watch(channelNameProvider);

    final rtcIdToken = await rtcVideoRepository.createRtcIdToken(
      channelName: channelName,
      localUid: RtcVideoState.localUid,
      account: RtcVideoState.account,
      rtcIdTokenType: RtcVideoState.rtcIdTokenType,
      role: RtcVideoState.role,
      privilegeExpireTime: RtcVideoState.privilegeExpireTime,
    );

    return rtcIdToken;
  }

  return execute;
});
