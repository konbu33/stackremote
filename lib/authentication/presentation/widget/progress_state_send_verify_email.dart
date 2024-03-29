import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/common.dart';

import '../../usecase/current_user_send_verify_email.dart';
import '../page/wait_email_verified_page_state.dart';

// --------------------------------------------------
//
//   progressStateSendVerifyEmailProvider
//
// --------------------------------------------------
final progressStateSendVerifyEmailProvider = Provider((ref) {
  //

  Future<void> sendVerifyEmail() async {
    final dateTimeNow = DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());
    void setMessage(String message) {
      ref
          .read(
              WaitEmailVerifiedPageState.attentionMessageStateProvider.notifier)
          .update((state) => "$dateTimeNow: $message");
    }

    // const message = "メール再送信中";
    // setMessage(message);

    // --------------------------------------------------
    //
    // メールアドレス検証メール送信
    //
    // --------------------------------------------------
    try {
      // メールアドレス検証メール送信
      final currentUserSendVerifyEmailUsecase =
          ref.read(currentUserSendVerifyEmailUsecaseProvider);

      await Future.delayed(const Duration(seconds: 1));
      await currentUserSendVerifyEmailUsecase();

      const String message = "メール再送しました。";
      setMessage(message);

      //
    } on StackremoteException catch (e) {
      setMessage(e.message);
    }

    //
  }

  return sendVerifyEmail;
});
