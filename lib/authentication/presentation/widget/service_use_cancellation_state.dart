import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import 'progress_state_service_use_cancellation.dart';

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
  //  changePasswordProgressStateNotifierProviderOfProvider
  //
  // --------------------------------------------------
  static final serviceUseCancellationProgressStateNotifierProviderOfProvider =
      Provider((ref) {
    final function = ref.watch(progressStateServiceUseCancellationProvider);

    return progressStateNotifierProviderCreator(function: function);
  });

  // --------------------------------------------------
  //
  //  serviceUseCancellationOnSubmitProvider
  //
  // --------------------------------------------------
  static final serviceUseCancellationOnSubmitProvider = Provider((ref) {
    void Function()? serviceUseCancellationOnSubmit() {
      //
      return () async {
        final serviceUseCancellationProgressStateNotifierProvider = ref.read(
            serviceUseCancellationProgressStateNotifierProviderOfProvider);
        ref
            .read(serviceUseCancellationProgressStateNotifierProvider.notifier)
            .updateProgress();
        //
      };
    }

    return serviceUseCancellationOnSubmit;
  });
}
