import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../usecase/service_signout.dart';
import '../page/wait_email_verified_page_state.dart';

// --------------------------------------------------
//
//   progressStateSignOutProvider
//
// --------------------------------------------------
final progressStateSignOutProvider = Provider((ref) {
  //

  Future<void> signOut() async {
    void setMessage(String message) {
      ref
          .read(
              WaitEmailVerifiedPageState.attentionMessageStateProvider.notifier)
          .update((state) => "${DateTime.now()}: $message");
    }

    const message = "サインアウト中";
    setMessage(message);

    // --------------------------------------------------
    //
    // サインアウト
    //
    // --------------------------------------------------
    try {
      final serviceSignOutUsecase = ref.read(serviceSignOutUsecaseProvider);

      await Future.delayed(const Duration(seconds: 1));
      await serviceSignOutUsecase();

      //
    } on StackremoteException catch (e) {
      setMessage(e.message);
    }

    //
  }

  return signOut;
});
