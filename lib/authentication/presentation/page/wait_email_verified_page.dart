import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../usecase/check_email_verified.dart';
import '../../usecase/current_user_send_verify_email.dart';
import '../widget/appbar_action_icon_widget.dart';

import 'wait_email_verified_page_state.dart';

class WaitEmailVerifiedPage extends HookConsumerWidget {
  const WaitEmailVerifiedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waitEmailVerifiedPageStateNotifierProvider);

    // メールアドレス確認が完了したか否かをポーリング開始
    final checkEmailVerifiedUsecase =
        ref.watch(checkEmailVerifiedUsecaseProvider);

    final checkEmailVerifiedTimer = checkEmailVerifiedUsecase();

    useEffect(() {
      //

      try {
        checkEmailVerifiedTimer;
      } on firebase_auth.FirebaseAuthException catch (e) {
        switch (e.code) {
          case "current-user-null":
            checkEmailVerifiedTimer.cancel();

            break;

          default:
            break;
        }
      }

      return checkEmailVerifiedTimer.cancel;
    }, [checkEmailVerifiedTimer]);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.pageTitle),
        actions: [
          WaitEmailVerifiedPageWidgets.signOutIconWidget(),
        ],
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: const [],
        children: [
          Column(
            children: [
              WaitEmailVerifiedPageWidgets.messageWidget(),
              const SizedBox(height: 30),
              WaitEmailVerifiedPageWidgets.sendVerifiyEmailWidget(),
            ],
          ),
        ],
      ),
    );
  }
}

class WaitEmailVerifiedPageWidgets {
  // signOutIconButton
  static Widget signOutIconWidget() {
    final Widget widget = Consumer(
      builder: ((context, ref, child) {
        final state = ref.watch(waitEmailVerifiedPageStateNotifierProvider);

        return AppbarAcitonIconWidget(
          appbarActionIconStateProvider: state.signOutIconStateProvider,
        );
      }),
    );

    return widget;
  }

  static Widget messageWidget() {
    String message = "";
    message += "あなたが「サービス利用登録時に登録したメールアドレス」の持ち主かどうか、確認待ちの状態です。";
    message += "\n\n\n";
    message += "「サービス利用登録時に登録したメールアドレス」へ、メールを送信しました。";
    message += "メール本文のリンクをクリックし、あなたがメールアドレスの持ち主であことを証明して下さい。";
    message += "\n\n\n";
    message += "もし、メールが届いていない場合、下記からメールを再送信可能です。";

    final Widget widget = Text(message);

    return widget;
  }

  static Widget sendVerifiyEmailWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      return ElevatedButton(
        onPressed: () async {
          // メールアドレス検証メール送信
          final currentUserSendVerifyEmailUsecase =
              ref.read(currentUserSendVerifyEmailUsecaseProvider);

          await currentUserSendVerifyEmailUsecase();
        },
        child: const Text("メール再送信"),
      );
    });

    return widget;
  }
}
