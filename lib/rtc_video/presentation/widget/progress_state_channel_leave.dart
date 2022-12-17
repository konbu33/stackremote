import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../usecase/channel_leave.dart';
import '../../usecase/channel_leave_clear_user_in_db.dart';
import '../page/rtc_video_channel_join_page_state.dart';

// --------------------------------------------------
//
//   progressStateChannelLeaveProvider
//
// --------------------------------------------------
final progressStateChannelLeaveProvider = Provider((ref) {
  //

  Future<void> channelLeave() async {
    final dateTimeNow = DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());
    void setMessage(String message) {
      ref
          .read(RtcVideoChannelJoinPageState
              .attentionMessageStateProvider.notifier)
          .update((state) => "$dateTimeNow: $message");
    }

    const message = "チャンネル離脱待機中";
    setMessage(message);

    // --------------------------------------------------
    //
    // チャンネル離脱
    //
    // --------------------------------------------------
    try {
      final channelLeaveUsecase = ref.read(channelLeaveUsecaseProvider);

      await Future.delayed(const Duration(seconds: 1));
      await channelLeaveUsecase();

      //
    } on Exception catch (e, s) {
      final message = "Channelからの離脱に失敗しました。$e, $s";
      setMessage(message);

      return;
    }

    // --------------------------------------------------
    //
    // DBのユーザ情報をクリア
    //
    // --------------------------------------------------
    try {
      final channelLeaveClearUserInDBUsecase =
          ref.read(channelLeaveClearUserInDBUsecaseProvider);
      await channelLeaveClearUserInDBUsecase();

      //
    } on Exception catch (e, s) {
      final message = "User情報のクリアに失敗しました。: $e, $s";
      setMessage(message);

      return;
    }

    //
  }

  return channelLeave;
});
