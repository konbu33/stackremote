import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../authentication/authentication.dart';
import '../../../authentication/usecase/service_use_cancellation.dart';
import '../../../common/common.dart';

class AlertDialogWidget extends StatefulHookConsumerWidget {
  const AlertDialogWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends ConsumerState<AlertDialogWidget> {
  // String message = "";

  final attentionMessageStateProvider = StateProvider((ref) => "");

  TextStyle style = const TextStyle(color: Colors.red);

  // void setMessage(String newMessage) {
  //   message = newMessage;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final message = ref.watch(attentionMessageStateProvider);

    return AlertDialog(
      title: const Text("サービス利用登録解除"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text("「サービス利用登録時に登録したメールアドレス」を削除し、サービスの利用を止めますか？"),
          message.isEmpty
              ? const SizedBox()
              : Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      message,
                      style: style,
                    ),
                  ],
                ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
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
              //   logger.d("$e");
              ref
                  .read(attentionMessageStateProvider.notifier)
                  .update((state) => e.message);
            }
          },
          child: const Text("はい"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("いいえ"),
        ),
      ],
    );
  }
}
