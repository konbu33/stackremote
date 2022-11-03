import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../usecase/verify_email.dart';

import '../widget/appbar_action_icon_widget.dart';

import 'wait_email_verified_page_state.dart';

class WaitEmailVerifiedPage extends HookConsumerWidget {
  const WaitEmailVerifiedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waitEmailVerifiedPageStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.pageTitle),
        actions: [
          WaitEmailVerifiedPageWidgets.signOutIconWidget(),
        ],
      ),
      body: ScaffoldBodyBaseLayoutWidget(
        focusNodeList: [],
        children: [
          Column(
            children: [
              WaitEmailVerifiedPageWidgets.messageWidget(),
              const SizedBox(height: 30),
              WaitEmailVerifiedPageWidgets.sendVerifiyEmailWidget(),
              const SizedBox(height: 30),
              WaitEmailVerifiedPageWidgets.verifiyEmailStateWidget(),
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
      final firebase_auth.User? user =
          firebase_auth.FirebaseAuth.instance.currentUser;

      final sendVerifyEmail = ref.read(sendVerifyEmailProvider);

      return ElevatedButton(
        onPressed: () {
          if (user != null) {
            sendVerifyEmail(user: user);
          }
        },
        child: const Text("メール再送信"),
      );
    });

    return widget;
  }

  static Widget verifiyEmailStateWidget() {
    final Widget widget = HookConsumer(builder: (context, ref, child) {
      // // サインインしたユーザの情報取得
      // final firebase_auth.User? user =
      //     firebase_auth.FirebaseAuth.instance.currentUser;

      // 他画面へ遷移する場合、checkEmailVerifiedのTimerがキャンセルされようにHooks利用する。
      final checkEmailVerified = ref.read(checkEmailVerifiedProvider);
      useEffect(() {
        checkEmailVerified;
        return checkEmailVerified.cancel;
      }, [checkEmailVerified]);

      // final state = ref.watch(firebaseAuthUserStateNotifierProvider);
      return Column(
        children: const [
          // Text(
          //   "firebaseAuthUser: ${DateTime.now()} $state",
          //   maxLines: 10,
          // ),
          // const Divider(),
          // Text(
          //   "currentUser  : ${DateTime.now()} $user",
          // ),
        ],
      );
    });

    return widget;
  }
}
