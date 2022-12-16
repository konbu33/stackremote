import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../usecase/current_user_send_verify_email.dart';
import '../../usecase/service_use_registration.dart';
import '../page/signup_page_state.dart';

// --------------------------------------------------
//
//   progressStateSignUpProvider
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

      // awaitで待つと、下記エラーが発生するため、awaitで待たず、非同期で実行する。
      // エラー原因は、推測だが、awaitで待っている間に、authStateChangesでログイン状態の変化を検知し、redirect処理が実行され、画面遷移が発生することが関連していると考えられる。
      // E/flutter (30541): [ERROR:flutter/lib/ui/ui_dart_state.cc(198)] Unhandled Exception: Bad state: Future already completed
      currentUserSendVerifyEmailUsecase();

      //
    } on StackremoteException catch (e) {
      setMessage(e.message);
    } on Exception catch (e) {
      logger.d(e.toString());
      setMessage(e.toString());
    }

    //
  }

  return signUp;
});
