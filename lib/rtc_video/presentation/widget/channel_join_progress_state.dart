import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../channel/domain/channel.dart';
import '../../../user/user.dart';
import '../../usecase/channel_leave.dart';
import '../page/agora_video_channel_join_page_state.dart';
import '../../usecase/channel_join.dart';
import '../../usecase/create_rtc_id_token.dart';
import '../../usecase/register_channel_and_user_in_db.dart';
import '../../domain/rtc_channel_state.dart';

// --------------------------------------------------
//
//   ChannelJoinProgressState
//
// --------------------------------------------------
class ChannelJoinProgressState extends AsyncNotifier<void> {
  @override
  void build() {
    // voidの場合、初期化不要。
  }

  void channelLeave() async {
    //

    void setMessage(String message) {
      ref
          .read(AgoraVideoChannelJoinPageState.messageProvider.notifier)
          .update((state) => message);
    }

    Future<void> execute() async {
      final message = "${DateTime.now()}: チャンネル離脱待機中";
      setMessage(message);

      // --------------------------------------------------
      //
      // チャンネル離脱
      //
      // --------------------------------------------------
      try {
        final channelLeaveUsecase = ref.read(channelLeaveUsecaseProvider);
        await channelLeaveUsecase();

        //
      } on Exception catch (e, s) {
        final message = "${DateTime.now()}: Channelからの離脱に失敗しました。$e, $s";
        setMessage(message);

        return;
      }

      // --------------------------------------------------
      //
      // DBのユーザ情報をクリア
      //
      // --------------------------------------------------
      try {
        final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);
        await userUpdateUsecase<FieldValue>(
          comment: "",
          leavedAt: FieldValue.serverTimestamp(),
          isOnLongPressing: false,
          pointerPosition: const Offset(0, 0),
          displayPointerPosition: const Offset(0, 0),
        );
      } on Exception catch (e, s) {
        final message = "${DateTime.now()}: User情報のクリアに失敗しました。: $e, $s";
        setMessage(message);

        return;
      }

      //
    }

    // まずローディング中であることを保持する。
    state = const AsyncLoading();

    // 結果を受けて、Data or Errorを保持する。
    state = await AsyncValue.guard(execute);
  }

  void channelJoin() async {
    //

    void setMessage(String message) {
      ref
          .read(AgoraVideoChannelJoinPageState.messageProvider.notifier)
          .update((state) => message);
    }

    Future<void> execute() async {
      final message = "${DateTime.now()}: チャンネル参加待機中";
      setMessage(message);

      // --------------------------------------------------
      //
      // チャンネル名をアプリ内で状態として保持する
      //
      // --------------------------------------------------
      final channelName = ref.watch(AgoraVideoChannelJoinPageState
          .channelNameFieldStateNotifierProvider
          .select((value) => value.channelNameFieldController.text));

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
        final message =
            "${DateTime.now()}: RTC_ID_TOKENの生成に失敗しました。: ${error.message}";
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
        final message = "${DateTime.now()}: Channelへの参加に失敗しました。$e, $s";
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
          ref.watch(registerChannelAndUserInDBUsecaseProvider);

      try {
        registerChannelAndUserInDBUsecase();
      } on Exception catch (e, s) {
        final message =
            "${DateTime.now()}: Channel or User情報の登録に失敗しました。: $e, $s";
        setMessage(message);

        return;
      }

      //
    }

    // まずローディング中であることを保持する。
    state = const AsyncLoading();

    // 結果を受けて、Data or Errorを保持する。
    state = await AsyncValue.guard(execute);
  }
}

// --------------------------------------------------
//
//   channelJoinProgressStateProviderCreator
//
// --------------------------------------------------
typedef ChannelJoinProgressStateProvider
    = AsyncNotifierProvider<ChannelJoinProgressState, void>;

ChannelJoinProgressStateProvider channelJoinProgressStateProviderCreator() {
  return AsyncNotifierProvider<ChannelJoinProgressState, void>(() {
    return ChannelJoinProgressState();
  });
}
