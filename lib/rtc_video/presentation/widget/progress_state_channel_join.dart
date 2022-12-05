import 'package:cloud_functions/cloud_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../channel/domain/channel.dart';
import '../page/rtc_video_channel_join_page_state.dart';
import '../../usecase/channel_join.dart';
import '../../usecase/create_rtc_id_token.dart';
import '../../usecase/channel_join_register_channel_and_user_in_db.dart';
import '../../domain/rtc_channel_state.dart';

// --------------------------------------------------
//
//   progressStateChannelJoinProvider
//
// --------------------------------------------------

final progressStateChannelJoinProvider = Provider((ref) {
  //

  Future<void> channelJoin() async {
    void setMessage(String message) {
      ref
          .read(RtcVideoChannelJoinPageState
              .attentionMessageStateProvider.notifier)
          .update((state) => "${DateTime.now()}: $message");
    }

    const message = "チャンネル参加待機中";

    setMessage(message);

    // --------------------------------------------------
    //
    // チャンネル名をアプリ内で状態として保持する
    //
    // --------------------------------------------------
    final channelNameFieldStateNotifierProvider = ref.watch(
        RtcVideoChannelJoinPageState
            .channelNameFieldStateNotifierProviderOfProvider);

    final channelName = ref.watch(channelNameFieldStateNotifierProvider
        .select((value) => value.textEditingController.text));

    ref.watch(channelNameProvider.notifier).update((state) => channelName);

    // --------------------------------------------------
    //
    // rtc_id_token取得
    //
    // --------------------------------------------------

    try {
      final createRtcIdTokenUsecase =
          ref.watch(createRtcIdTokenUsecaseProvider);

      final rtcIdToken = await createRtcIdTokenUsecase();

      ref
          .watch(RtcChannelState.rtcIdTokenProvider.notifier)
          .update((state) => rtcIdToken);

      //
    } on FirebaseFunctionsException catch (error) {
      final message = "RTC_ID_TOKENの生成に失敗しました。: ${error.message}";
      setMessage(message);

      return;
    }

    // --------------------------------------------------
    //
    // チャンネル参加
    //
    // --------------------------------------------------
    try {
      final channelJoinUsecase = ref.read(channelJoinUsecaseProvider);
      await channelJoinUsecase();

      //
    } on Exception catch (e, s) {
      final message = "Channelへの参加に失敗しました。$e, $s";
      setMessage(message);

      return;
    }

    //
    // --------------------------------------------------
    //
    // DBにチャンネル情報とユーザ情報を登録
    //
    // --------------------------------------------------
    final registerChannelAndUserInDBUsecase =
        ref.watch(channelJoinRegisterChannelAndUserInDBUsecaseProvider);

    try {
      registerChannelAndUserInDBUsecase();
    } on Exception catch (e, s) {
      final message = "Channel or User情報の登録に失敗しました。: $e, $s";
      setMessage(message);

      return;
    }

    //
  }

  return channelJoin;
});
