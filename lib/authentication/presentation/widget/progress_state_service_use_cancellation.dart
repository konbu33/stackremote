import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../../authentication.dart';
import '../../usecase/service_use_cancellation.dart';
import 'service_use_cancellation_state.dart';

// --------------------------------------------------
//
//   progressStateSignOutProvider
//
// --------------------------------------------------
final progressStateServiceUseCancellationProvider = Provider((ref) {
  //

  Future<void> serviceUseCancellation() async {
    void setMessage(String message) {
      ref
          .read(ServiceUseCancellationState
              .attentionMessageStateProvider.notifier)
          .update((state) => "${DateTime.now()}: $message");
    }

    const message = "サービス利用登録解除中";
    setMessage(message);

    // --------------------------------------------------
    //
    // サービス利用登録解除
    //
    // --------------------------------------------------
    final serviceUseCancellationUsecase =
        ref.read(serviceUseCancellationUsecaseProvider);

    try {
      await Future.delayed(const Duration(seconds: 1));
      await serviceUseCancellationUsecase();

      const message = "登録したメールアドレスを削除しました。";
      setMessage(message);

      await Future.delayed(const Duration(seconds: 1));
      final notifier = ref.read(firebaseAuthUserStateNotifierProvider.notifier);
      notifier.updateIsSignIn(false);

      //
    } on StackremoteException catch (e) {
      setMessage(e.message);

      switch (e.code) {
        case "requires-recent-login":
          //
          ref
              .read(ServiceUseCancellationState
                  .isVisibleYesButtonProvider.notifier)
              .update((state) => false);

          break;

        default:
      }
    }
  }

  return serviceUseCancellation;
});