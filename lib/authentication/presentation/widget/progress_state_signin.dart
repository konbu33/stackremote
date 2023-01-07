import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

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
    final dateTimeNow = DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());
    void setMessage(String message) {
      ref
          .read(SignInPageState.attentionMessageStateProvider.notifier)
          .update((state) => "$dateTimeNow: $message");
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
    } on Exception catch (e) {
      logger.d(e.toString());
      setMessage(e.toString());
    }

    //
  }

  return signIn;
});
