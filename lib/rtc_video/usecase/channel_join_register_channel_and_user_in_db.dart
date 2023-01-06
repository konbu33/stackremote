import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../channel/channel.dart';
import '../../common/common.dart';
import '../../user/user.dart';

final channelJoinRegisterChannelAndUserInDBUsecaseProvider =
    Provider.autoDispose((ref) {
  //

  Future<void> execute() async {
    //
    bool isExistChannel = true;

    // チャンネルが存在する場合
    try {
      // チャンネルのデータ取得
      final channelGetUsecase = ref.watch(channelGetUsecaseProvider);
      await channelGetUsecase();
      //
    } on StackremoteException catch (e) {
      logger.d("$e");
      switch (e.code) {

        // チャンネルが存在しない場合
        case "not_exists":
          isExistChannel = false;

          break;

        //
        default:
          break;
      }
    }

    // チャンネルが存在しない場合
    if (!isExistChannel) {
      // チャンネル登録
      final channelSetUsecase = ref.watch(channelSetUsecaseProvider);
      await channelSetUsecase();
    }

    // channel情報取得し、アプリ内で保持
    ref.invalidate(channelStateFutureProvider);

    // ユーザ登録
    final userSetUsecase = ref.watch(userSetUsecaseProvider);
    await userSetUsecase();

    //
  }

  return execute;
});
