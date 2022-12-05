import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../usecase/channel_leave.dart';
import '../../usecase/channel_leave_clear_user_in_db.dart';
import '../page/agora_video_channel_join_page_state.dart';

// --------------------------------------------------
//
//   channelLeaveProgressFunctionProvider
//
// --------------------------------------------------
final channelLeaveProgressFunctionProvider = Provider((ref) {
  //

  Future<void> channelLeave() async {
    void setMessage(String message) {
      ref
          .read(AgoraVideoChannelJoinPageState
              .attentionMessageStateProvider.notifier)
          .update((state) => "${DateTime.now()}: $message");
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
