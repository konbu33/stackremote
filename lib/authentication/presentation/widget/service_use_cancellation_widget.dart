import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/presentation/widget/service_use_cancellation_state.dart';

class ServiceUseCancellationWidget extends HookConsumerWidget {
  const ServiceUseCancellationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: ServiceUseCancellationWidgetParts.buildTitleWidget(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          ServiceUseCancellationWidgetParts.buildDescriptionMessageWidget(),
          ServiceUseCancellationWidgetParts.buildAttentionMessageWidget(),
        ],
      ),
      actions: [
        ServiceUseCancellationWidgetParts.buildYesButtonWidget(),
        ServiceUseCancellationWidgetParts.buildNoButtonWidget(),
      ],
    );
  }
}

class ServiceUseCancellationWidgetParts {
  //
  static Widget buildTitleWidget() {
    Widget widget = const Text("サービス利用登録解除");

    return widget;
  }

  //
  static Widget buildDescriptionMessageWidget() {
    Widget widget = const Text("「サービス利用登録時に登録したメールアドレス」を削除し、サービスの利用を止めますか？");

    return widget;
  }

  //
  static Widget buildAttentionMessageWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      //

      TextStyle style = const TextStyle(color: Colors.red);

      final attentionMessage =
          ref.watch(ServiceUseCancellationState.attentionMessageStateProvider);

      if (attentionMessage.isEmpty) return const SizedBox();

      return Column(
        children: [
          const SizedBox(height: 30),
          Text(
            attentionMessage,
            style: style,
          ),
        ],
      );
    });

    return widget;
  }

  //
  static Widget buildYesButtonWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      //
      final isVisibleYesButton =
          ref.watch(ServiceUseCancellationState.isVisibleYesButtonProvider);

      final serviceUseCancellationOnSubmit = ref.watch(
          ServiceUseCancellationState.serviceUseCancellationOnSubmitProvider);

      return TextButton(
        onPressed: isVisibleYesButton ? serviceUseCancellationOnSubmit() : null,
        child: const Text("はい"),
      );
    });

    return widget;
  }

  //
  static Widget buildNoButtonWidget() {
    Widget widget = Consumer(builder: (context, ref, child) {
      //
      return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("いいえ"),
      );
    });

    return widget;
  }
}
