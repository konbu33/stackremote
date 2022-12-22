import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

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
    final dateTimeNow = DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());
    void setMessage(String message) {
      ref
          .read(ServiceUseCancellationState
              .attentionMessageStateProvider.notifier)
          .update((state) => "$dateTimeNow: $message");
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
      await serviceUseCancellationUsecase();

      const message = "登録したメールアドレスを削除しました。";
      setMessage(message);

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
    } on Exception catch (e) {
      logger.d(e.toString());
      setMessage(e.toString());
    }
  }

  return serviceUseCancellation;
});
