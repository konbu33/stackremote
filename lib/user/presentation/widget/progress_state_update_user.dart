import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../domain/user.dart';
import '../page/user_page_state.dart';

// --------------------------------------------------
//
//   progressStateUpdateUserProvider
//
// --------------------------------------------------
final progressStateUpdateUserProvider = Provider.autoDispose((ref) {
  //

  Future<void> updateUser() async {
    void setMessage(String message) {
      ref
          .read(UserPageState.attentionMessageStateProvider.notifier)
          .update((state) => "${DateTime.now()}: $message");
    }

    const message = "ユーザ情報更新中";
    setMessage(message);

    // --------------------------------------------------
    //
    // ユーザ情報更新
    //
    // --------------------------------------------------
    try {
      final nickNameFieldStateNotifierProvider =
          ref.watch(UserPageState.nickNameFieldStateNotifierProviderOfProvider);

      final nickName = ref
          .read(nickNameFieldStateNotifierProvider)
          .textEditingController
          .text;

      // ユーザ情報更新
      final userStateNotifier = ref.read(userStateNotifierProvider.notifier);

      await Future.delayed(const Duration(seconds: 1));
      userStateNotifier.setNickName(nickName);

      setMessage("ユーザ情報を更新しました。");

      //
    } on StackremoteException catch (e) {
      setMessage(e.message);
    }

    //
  }

  return updateUser;
});
