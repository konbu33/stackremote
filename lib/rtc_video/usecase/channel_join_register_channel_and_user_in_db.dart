import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/authentication.dart';
import '../../channel/channel.dart';
import '../../common/common.dart';
import '../../user/user.dart';

final channelJoinRegisterChannelAndUserInDBUsecaseProvider = Provider((ref) {
  //

  Future<void> execute() async {
    //
    bool isExistChannel = true;

    // チャンネルが存在する場合
    try {
      // チャンネルのデータ取得
      final channelGetUsecase = ref.watch(channelGetUsecaseProvider);
      final channel = await channelGetUsecase();

      // チャンネル情報をアプリ内の状態として保持
      final channelStateNotifier =
          ref.watch(channelStateNotifierProvider.notifier);
      channelStateNotifier.setChannelState(channel);

      // チャンネルのホストユーザか否か確認、ホストユーザ以外の場合
      final channelState = ref.watch(channelStateNotifierProvider);
      final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);

      if (channelState.hostUserEmail != firebaseAuthUser.email) {
        final userStateNotifier = ref.watch(userStateNotifierProvider.notifier);
        userStateNotifier.updateIsHost(false);
      }

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

      // チャンネルのデータ取得
      final channelGetUsecase = ref.watch(channelGetUsecaseProvider);
      final channel = await channelGetUsecase();

      // チャンネルが存在する場合
      // チャンネル情報をアプリ内の状態として保持
      final channelStateNotifier =
          ref.watch(channelStateNotifierProvider.notifier);
      channelStateNotifier.setChannelState(channel);
    }

    // ユーザ登録
    final userSetUsecase = ref.watch(userSetUsecaseProvider);
    await userSetUsecase();

    //
  }

  return execute;
});
