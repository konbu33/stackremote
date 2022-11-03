import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../authentication/authentication.dart';
import '../../../authentication/common/create_firebse_exception_message.dart';
import '../../../common/common.dart';

class AlertDialogWidget extends StatefulHookConsumerWidget {
  const AlertDialogWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends ConsumerState<AlertDialogWidget> {
  String message = "";
  TextStyle style = const TextStyle(color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("サービス利用登録解除"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text("「サービス利用登録時に登録したメールアドレス」を削除し、サービスの利用を止めますか？"),
          Text(
            message,
            style: style,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              try {
                await user.delete();
                message = "登録したメールアドレスを削除しました。";
                setState(() {});

                sleep(const Duration(seconds: 3));

                final notifier =
                    ref.read(firebaseAuthUserStateNotifierProvider.notifier);
                notifier.updateIsSignIn(false);
              } on FirebaseException catch (e) {
                logger.d("$e");

                final createFirebaseExceptionMessage =
                    ref.read(createFirebaseExceptionMessageProvider);
                message = createFirebaseExceptionMessage(e);
                setState(() {});
                // notifier.setMessage(message);

              }
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
