import 'package:cloud_functions/cloud_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../channel/channel.dart';

import '../domain/rtc_channel_state.dart';
import '../infrastructure/rtc_video_repository.dart';
import '../infrastructure/rtc_video_repository_agora.dart';

final createRtcIdTokenUsecaseProvider = Provider((ref) async {
  final RtcVideoRepository rtcVideoRepository =
      await ref.watch(rtcVideoRepositoryAgoraProvider);

  final channelName = ref.watch(channelNameProvider);

  // --------------------------------------------------
  //
  // rtc_id_token取得
  //
  // --------------------------------------------------
  // String rtcIdToken;
  Future<String> execute() async {
    String rtcIdToken = "";

    try {
      rtcIdToken = await rtcVideoRepository.createRtcIdToken(
        channelName: channelName,
        localUid: RtcChannelState.localUid,
        account: RtcChannelState.account,
        rtcIdTokenType: RtcChannelState.rtcIdTokenType,
        role: RtcChannelState.role,
        privilegeExpireTime: RtcChannelState.privilegeExpireTime,
      );
    } on FirebaseFunctionsException catch (_) {
      rethrow;
    }

    return rtcIdToken;
  }

  return execute;
});
