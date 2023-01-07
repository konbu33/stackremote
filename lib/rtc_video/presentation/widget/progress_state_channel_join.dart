import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../channel/channel.dart';
import '../../../common/common.dart';

import '../../domain/rtc_video_state.dart';

import '../../usecase/channel_join_register_channel_and_user_in_db.dart';
import '../../usecase/channel_join.dart';
import '../../usecase/channel_leave_clear_user_in_db.dart';
import '../../usecase/channel_leave.dart';
import '../../usecase/create_rtc_id_token.dart';

import '../page/rtc_video_channel_join_page_state.dart';

// --------------------------------------------------
//
//   progressStateChannelJoinProvider
//
// --------------------------------------------------

final progressStateChannelJoinProvider = Provider.autoDispose((ref) {
  //

  Future<void> channelJoin() async {
    final dateTimeNow = DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());
    void setMessage(String message) {
      ref
          .read(RtcVideoChannelJoinPageState
              .attentionMessageStateProvider.notifier)
          .update((state) => "$dateTimeNow: $message");
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
          .watch(RtcVideoState.rtcIdTokenProvider.notifier)
          .update((state) => rtcIdToken);

      //
    } on StackremoteException catch (error) {
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
    } on PlatformException catch (e) {
      logger.d(
          "code: ${e.code}, message: ${e.message}, details: ${e.details}, stackTrace: ${e.stacktrace}");

      // --------------------------------------------------
      // ChannelJoinがReject発生した場合、明示的にLeaveした後、再度Join実施
      // --------------------------------------------------
      final errorMessage = e.message ?? "";
      if (errorMessage.contains(RegExp('join.*reject'))) {
        //
        final message = "Channelへの参加が拒否されました。$e";
        setMessage(message);

        // channelLeave
        final channelLeaveUsecase = ref.read(channelLeaveUsecaseProvider);
        await channelLeaveUsecase();

        // channelLeaveClearUserInDB
        final channelLeaveClearUserInDBUsecase =
            ref.read(channelLeaveClearUserInDBUsecaseProvider);
        await channelLeaveClearUserInDBUsecase();

        // channelJoin
        final channelJoinUsecase = ref.read(channelJoinUsecaseProvider);
        await channelJoinUsecase();
      }

      //
    } on Exception catch (e) {
      final message = "Channelへの参加に失敗しました。$e";
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
      unawaited(registerChannelAndUserInDBUsecase());
    } on Exception catch (e, s) {
      final message = "Channel or User情報の登録に失敗しました。: $e, $s";
      setMessage(message);

      return;
    }

    //
  }

  return channelJoin;
});
