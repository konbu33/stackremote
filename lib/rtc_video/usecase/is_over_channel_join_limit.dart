import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../../user/user.dart';
import '../domain/rtc_video_state.dart';

final isOverChannelJoinLimitUsecaseProvider = Provider.autoDispose((ref) {
  //
  Future<bool> execute() async {
    //
    const limit = RtcVideoState.channelJoinLimit;
    bool isOverChannelJoinLimit = false;

    try {
      final userGetAllUsecase = ref.watch(userGetAllUsecaseProvider);
      final users = await userGetAllUsecase();

      // 参加中のuserのみのリスト作成
      final userList = users.users;
      final joinUserList = userList.where((user) {
        return user.leavedAt == null;
      }).toList();

      logger.d(
          "isOverChannelJoinLimit: limit: $limit, joining: ${joinUserList.length}");
      if (joinUserList.length >= limit) {
        isOverChannelJoinLimit = true;
      }

      return isOverChannelJoinLimit;

      //
    } on StackremoteException catch (e) {
      logger.d("$e");
      rethrow;
    }
  }

  return execute;
});
