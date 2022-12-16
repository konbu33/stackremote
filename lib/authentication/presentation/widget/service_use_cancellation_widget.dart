import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import 'service_use_cancellation_state.dart';

class ServiceUseCancellationWidget extends HookConsumerWidget {
  const ServiceUseCancellationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: ServiceUseCancellationWidgetParts.titleWidget(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          ServiceUseCancellationWidgetParts.descriptionMessageWidget(),
          const SizedBox(height: 30),
          Stack(
            children: [
              ServiceUseCancellationWidgetParts.attentionMessageWidget(),
              ServiceUseCancellationWidgetParts
                  .serviceUseCancellationProgressWidget(),
            ],
          ),
        ],
      ),
      actions: [
        ServiceUseCancellationWidgetParts.yesButtonWidget(),
        ServiceUseCancellationWidgetParts.noButtonWidget(),
      ],
    );
  }
}

class ServiceUseCancellationWidgetParts {
  // titleWidget
  static Widget titleWidget() {
    Widget widget = const Text("サービス利用登録解除");

    return widget;
  }

  // descriptionMessageWidget
  static Widget descriptionMessageWidget() {
    Widget widget = const Text("「サービス利用登録時に登録したメールアドレス」を削除し、サービスの利用を止めますか？");

    return widget;
  }

  // attentionMessageWidget
  static Widget attentionMessageWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      //

      TextStyle style = const TextStyle(color: Colors.red);

      final attentionMessage =
          ref.watch(ServiceUseCancellationState.attentionMessageStateProvider);

      if (attentionMessage.isEmpty) return const SizedBox();

      return Column(
        children: [
          Text(
            attentionMessage,
            style: style,
          ),
        ],
      );
    });

    return widget;
  }

  // yesButtonWidget
  static Widget yesButtonWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      //
      final isVisibleYesButton =
          ref.watch(ServiceUseCancellationState.isVisibleYesButtonProvider);

      final serviceUseCancellationOnSubmit = ref.watch(
          ServiceUseCancellationState.serviceUseCancellationOnSubmitProvider);

      return isVisibleYesButton
          ? TextButton(
              onPressed: serviceUseCancellationOnSubmit(),
              child: const Text("はい"),
            )
          : const SizedBox();
    });

    return widget;
  }

  // noButtonWidget
  static Widget noButtonWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      //
      final isVisibleYesButton =
          ref.watch(ServiceUseCancellationState.isVisibleYesButtonProvider);

      final buttonDisplayName = isVisibleYesButton ? "いいえ" : "閉じる";

      return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(buttonDisplayName),
      );
    });

    return widget;
  }

  // serviceUseCancellationProgressWidget
  static Widget serviceUseCancellationProgressWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final serviceUseCancellationProgressStateNotifierProvider = ref.watch(
        ServiceUseCancellationState
            .serviceUseCancellationProgressStateNotifierProviderOfProvider,
      );

      return ProgressWidget(
        progressStateNotifierProvider:
            serviceUseCancellationProgressStateNotifierProvider,
      );
    });

    return widget;
  }
}
