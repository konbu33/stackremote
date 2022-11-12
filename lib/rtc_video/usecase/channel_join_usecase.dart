import 'package:cloud_functions/cloud_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/authentication.dart';
import '../../channel/channel.dart';
import '../../channel/domain/channel_exception.dart';
import '../../common/common.dart';
import '../../user/user.dart';
import '../infrastructure/rtc_channel_join_provider.dart';
import '../infrastructure/rtc_token_create_provider.dart';
import '../presentation/page/agora_video_channel_join_page_state.dart';
import '../presentation/widget/channel_name_field_state.dart';
import '../rtc_video.dart';

// final channelJoinUsecaseProvider = FutureProvider((ref) async {
final channelJoinUsecaseProvider = Provider((ref) {
  Future<void> channelJoinUsecase() async {
    // --------------------------------------------------
    //
    // チャンネル名をアプリ内で状態として保持する
    //
    // --------------------------------------------------
    final notifier = ref.read(RtcChannelStateNotifierProviderList
        .rtcChannelStateNotifierProvider.notifier);

    final state = ref.read(ChannelNameFieldStateNotifierProviderList
        .channelNameFieldStateNotifierProvider);

    final channelName = state.channelNameFieldController.text;

    notifier.updateChannelName(channelName);

    // --------------------------------------------------
    //
    // rtc_id_token取得
    //
    // --------------------------------------------------
    final rtcCreateToken = ref.read(rtcTokenCreateOnCallProvider);

    try {
      await rtcCreateToken();
    } on FirebaseFunctionsException catch (error) {
      final notifier =
          ref.read(agoraVideoChannelJoinPageStateNotifierProvider.notifier);
      notifier.setMessage(error.message ?? "no message");

      // final snackBar = SnackBar(
      //   margin: const EdgeInsets.fromLTRB(30, 0, 30, 50),
      //   behavior: SnackBarBehavior.floating,
      //   backgroundColor: Colors.cyan,
      //   duration: const Duration(seconds: 5),
      //   content: Text(
      //     "ERROR : ${error.message}",
      //     style: const TextStyle(
      //       fontSize: 16,
      //     ),
      //   ),
      // );

      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // --------------------------------------------------
    //
    // チャンネル参加
    //
    // --------------------------------------------------
    final rtcJoinChannel = ref.read(rtcJoinChannelProvider);
    await rtcJoinChannel();

    // --------------------------------------------------
    //
    // DBにチャンネル情報とユーザ情報を登録
    //
    // --------------------------------------------------

    try {
      // チャンネルのデータ取得
      final channelGetUsecase = ref.read(channelGetUsecaseProvider);
      final channel = await channelGetUsecase();

      // チャンネルが存在する場合
      // チャンネル情報をアプリ内の状態として保持
      final channelStateNotifier =
          ref.read(channelStateNotifierProvider.notifier);
      channelStateNotifier.setChannelState(channel);

      // チャンネルのホストユーザか否か確認、ホストユーザ以外の場合
      final channelState = ref.read(channelStateNotifierProvider);
      final firebaseAuthUser = ref.read(firebaseAuthUserStateNotifierProvider);

      if (channelState.hostUserEmail != firebaseAuthUser.email) {
        final userStateNotifier = ref.read(userStateNotifierProvider.notifier);
        userStateNotifier.updateIsHost(false);
      }

      //
    } on Exception catch (e) {
      if (e is ChannelException) {
        logger.d("$e");
        switch (e.code) {

          // チャンネルが存在しない場合
          case "not_exists":

            // チャンネル登録
            final channelSetUsecase = ref.read(channelSetUsecaseProvider);
            await channelSetUsecase();

            // チャンネルのデータ取得
            final channelGetUsecase = ref.read(channelGetUsecaseProvider);
            final channel = await channelGetUsecase();

            // チャンネルが存在する場合
            // チャンネル情報をアプリ内の状態として保持
            final channelStateNotifier =
                ref.read(channelStateNotifierProvider.notifier);
            channelStateNotifier.setChannelState(channel);

            break;

          //
          default:
            break;
        }
      }
    }

    // ユーザ登録
    final userSetUsecase = ref.read(userSetUsecaseProvider);
    await userSetUsecase();

    // --------------------------------------------------
    //
    // チャンネル参加済みであることをアプリ内で状態として保持する
    //
    // --------------------------------------------------
    notifier.changeJoined(true);
  }

  return channelJoinUsecase;
});
