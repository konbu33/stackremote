import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

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
    final dateTimeNow = DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());
    void setMessage(String message) {
      ref
          .read(
              WaitEmailVerifiedPageState.attentionMessageStateProvider.notifier)
          .update((state) => "$dateTimeNow: $message");
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

      const String message = "サインアウトしました。";
      setMessage(message);

      //
    } on StackremoteException catch (e) {
      setMessage(e.message);
    }

    //
  }

  return signOut;
});
