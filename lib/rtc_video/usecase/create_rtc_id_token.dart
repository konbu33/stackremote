import 'package:cloud_functions/cloud_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../channel/channel.dart';

import '../domain/rtc_channel_state.dart';
import '../infrastructure/rtc_video_repository.dart';
import '../infrastructure/rtc_video_repository_agora.dart';

final createRtcIdTokenUsecaseProvider = Provider((ref) {
  Future<String> execute() async {
    final rtcVideoRepositoryAgoraCreator =
        ref.watch(rtcVideoRepositoryAgoraCreatorProvider);

    final RtcVideoRepository rtcVideoRepository =
        await rtcVideoRepositoryAgoraCreator();

    final channelName = ref.watch(channelNameProvider);

    try {
      final rtcIdToken = await rtcVideoRepository.createRtcIdToken(
        channelName: channelName,
        localUid: RtcChannelState.localUid,
        account: RtcChannelState.account,
        rtcIdTokenType: RtcChannelState.rtcIdTokenType,
        role: RtcChannelState.role,
        privilegeExpireTime: RtcChannelState.privilegeExpireTime,
      );

      return rtcIdToken;
    } on FirebaseFunctionsException catch (_) {
      rethrow;
    }
  }

  return execute;
});
