import 'package:cloud_functions/cloud_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../channel/channel.dart';
import '../../common/common.dart';

import '../domain/rtc_channel_state.dart';
import '../infrastructure/rtc_video_repository.dart';
import '../infrastructure/rtc_video_repository_agora.dart';
import '../presentation/page/agora_video_channel_join_page_state.dart';
import 'register_channel_and_user_in_db.dart';

final channelJoinUsecaseProvider = Provider((ref) async {
  final RtcVideoRepository rtcVideoRepository =
      await ref.watch(rtcVideoRepositoryAgoraProvider);

  Future<void> execute() async {
    final message = "${DateTime.now()}: チャンネル参加待機中";

    ref
        .read(AgoraVideoChannelJoinPageState.messageProvider.notifier)
        .update((state) => message);

    // --------------------------------------------------
    //
    // チャンネル名をアプリ内で状態として保持する
    //
    // --------------------------------------------------
    final channelName = ref.watch(AgoraVideoChannelJoinPageState
        .channelNameFieldStateNotifierProvider
        .select((value) => value.channelNameFieldController.text));

    ref.watch(channelNameProvider.notifier).update((state) => channelName);

    // // --------------------------------------------------
    // //
    // // rtc_id_token取得
    // //
    // // --------------------------------------------------
    final String rtcIdToken;

    try {
      rtcIdToken = await ref.watch(RtcChannelState.rtcIdTokenProvider);
      logger.d("rtcIdToken : $rtcIdToken");

      //
    } on FirebaseFunctionsException catch (error) {
      final message =
          "${DateTime.now()}: RTC_ID_TOKENの生成に失敗しました。: ${error.message}";

      ref
          .read(AgoraVideoChannelJoinPageState.messageProvider.notifier)
          .update((state) => message);

      return;
    }

    // --------------------------------------------------
    //
    // チャンネル参加
    //
    // --------------------------------------------------
    try {
      await rtcVideoRepository.channelJoin(
        token: rtcIdToken,
        channelName: channelName,
        optionalInfo: null,
        optionalUid: RtcChannelState.localUid,
      );

      //
    } on Exception catch (e, s) {
      final message = "${DateTime.now()}: Channelへの参加に失敗しました。$e, $s";

      ref
          .read(AgoraVideoChannelJoinPageState.messageProvider.notifier)
          .update((state) => message);

      return;
    }

    //
    // --------------------------------------------------
    //
    // DBにチャンネル情報とユーザ情報を登録
    //
    // --------------------------------------------------
    final registerChannelAndUserInDB =
        ref.watch(registerChannelAndUserInDBProvider);

    try {
      registerChannelAndUserInDB();
    } on Exception catch (e, s) {
      final message = "${DateTime.now()}: Channel or User情報の登録に失敗しました。: $e, $s";
      ref
          .read(AgoraVideoChannelJoinPageState.messageProvider.notifier)
          .update((state) => message);
    }

    // --------------------------------------------------
    //
    // チャンネル参加済みであることをアプリ内で状態として保持する
    //
    // --------------------------------------------------
    ref.read(RtcChannelState.isJoinedProvider.notifier).update((state) => true);

    //
  }

  return execute;
});
