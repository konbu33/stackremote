import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../usecase/service_signin.dart';
import '../page/signin_page_state.dart';

// --------------------------------------------------
//
//   progressStateChannelLeaveProvider
//
// --------------------------------------------------
final progressStateSignInProvider = Provider.autoDispose((ref) {
  //

  Future<void> signIn() async {
    void setMessage(String message) {
      ref
          .read(SignInPageState.attentionMessageStateProvider.notifier)
          .update((state) => "${DateTime.now()}: $message");
    }

    const message = "サインイン中";
    setMessage(message);

    // --------------------------------------------------
    //
    // サインイン
    //
    // --------------------------------------------------
    try {
      final loginIdFieldStateNotifierProvider = ref
          .watch(SignInPageState.loginIdFieldStateNotifierProviderOfProvider);

      final passwordFieldStateProvider =
          ref.watch(SignInPageState.passwordFieldStateProviderOfProvider);

      final email = ref
          .read(loginIdFieldStateNotifierProvider)
          .textEditingController
          .text;

      final password =
          ref.read(passwordFieldStateProvider).passwordFieldController.text;

      // サインイン
      final serviceSignInUsecase = ref.read(serviceSignInUsecaseProvider);

      await serviceSignInUsecase(email, password);

      //
    } on StackremoteException catch (e) {
      setMessage(e.message);
    }

    //
  }

  return signIn;
});
