import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication.dart';
import '../../usecase/service_use_cancellation.dart';
import '../../../common/common.dart';

class ServiceUseCancellationState {
  // --------------------------------------------------
  //
  //  isVisibleYesButtonProvider
  //  attentionMessageStateProvider
  //
  // --------------------------------------------------
  static final isVisibleYesButtonProvider =
      StateProvider.autoDispose((ref) => true);

  static final attentionMessageStateProvider =
      StateProvider.autoDispose((ref) => "");

  // --------------------------------------------------
  //
  //  serviceUseCancellationOnSubmitProvider
  //
  // --------------------------------------------------
  static final serviceUseCancellationOnSubmitProvider = Provider((ref) {
    void Function()? serviceUseCancellationOnSubmit() {
      //
      return () async {
        final serviceUseCancellationUsecase =
            ref.read(serviceUseCancellationUsecaseProvider);

        try {
          await serviceUseCancellationUsecase();
          const message = "登録したメールアドレスを削除しました。";
          ref
              .read(attentionMessageStateProvider.notifier)
              .update((state) => message);

          sleep(const Duration(seconds: 3));

          final notifier =
              ref.read(firebaseAuthUserStateNotifierProvider.notifier);
          notifier.updateIsSignIn(false);

          //
        } on StackremoteException catch (e) {
          ref
              .read(attentionMessageStateProvider.notifier)
              .update((state) => e.message);

          switch (e.code) {
            case "requires-recent-login":
              //
              ref
                  .read(isVisibleYesButtonProvider.notifier)
                  .update((state) => false);

              break;

            default:
          }
        }
      };
    }

    return serviceUseCancellationOnSubmit;
  });
}
