import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../usecase/current_user_send_verify_email.dart';
import '../../usecase/service_use_registration.dart';
import '../page/signup_page_state.dart';

// --------------------------------------------------
//
//   progressStateChannelLeaveProvider
//
// --------------------------------------------------
final progressStateSignUpProvider = Provider.autoDispose((ref) {
  //

  Future<void> signUp() async {
    void setMessage(String message) {
      ref
          .read(SignUpPageState.attentionMessageStateProvider.notifier)
          .update((state) => "${DateTime.now()}: $message");
    }

    const message = "サービス利用登録中";
    setMessage(message);

    // --------------------------------------------------
    //
    // サインイン
    //
    // --------------------------------------------------
    try {
      final loginIdFieldStateNotifierProvider = ref
          .watch(SignUpPageState.loginIdFieldStateNotifierProviderOfProvider);

      final passwordFieldStateProvider =
          ref.watch(SignUpPageState.passwordFieldStateProviderOfProvider);

      final email = ref
          .read(loginIdFieldStateNotifierProvider)
          .textEditingController
          .text;

      final password =
          ref.read(passwordFieldStateProvider).passwordFieldController.text;

      // サービス利用登録
      final serviceUseRegistrationUsecase =
          ref.read(serviceUseRegistrationUsecaseProvider);

      await serviceUseRegistrationUsecase(email, password);

      // メールアドレス検証メール送信
      final currentUserSendVerifyEmailUsecase =
          ref.read(currentUserSendVerifyEmailUsecaseProvider);

      await currentUserSendVerifyEmailUsecase();
      //
    } on StackremoteException catch (e) {
      setMessage(e.message);
    }

    //
  }

  return signUp;
});
