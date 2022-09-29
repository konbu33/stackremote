import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/domain/firebase_auth_user.dart';
import 'package:stackremote/presentation/verify_email.dart';

import '../widget/appbar_action_icon_widget.dart';
import '../widget/base_layout_widget.dart';
import 'agora_video_channel_join_page_state.dart';

class WaitEmailVerifiedPage extends StatelessWidget {
  const WaitEmailVerifiedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("メールアドレス検証中"),
        actions: [
          WaitEmailVerifiedPageWidgets.signOutIconWidget(),
        ],
      ),
      body: BaseLayoutWidget(
        children: [
          Column(
            children: [
              WaitEmailVerifiedPageWidgets.messageWidget(),
              const SizedBox(height: 30),
              WaitEmailVerifiedPageWidgets.sendVerifiyEmailWidget(),
              const SizedBox(height: 30),
              WaitEmailVerifiedPageWidgets.verifiyEmailStateWidget(),
              const SizedBox(height: 30),
              WaitEmailVerifiedPageWidgets.userReloadWidget(),
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
        final state = ref.watch(agoraVideoChannelJoinPageStateNotifierProvider);

        return AppbarAcitonIconWidget(
          appbarActionIconStateProvider: state.signOutIconStateProvider,
        );
      }),
    );

    return widget;
  }

  static Widget messageWidget() {
    const message =
        "メールアドレス検証待ちの状態です。\nメール本文のリンクをクリックし、メールアドレスの持ち主であことを証明してください。";

    const Widget widget = Text(message);

    return widget;
  }

  static Widget sendVerifiyEmailWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final firebase_auth.User? user =
          firebase_auth.FirebaseAuth.instance.currentUser;

      final sendVerifyEmail = ref.read(sendVerifyEmailProvider);

      return ElevatedButton(
        onPressed: () {
          print("メール送信");
          if (user != null) {
            sendVerifyEmail(user: user);
          }
        },
        child: const Text("メール送信"),
      );
    });

    return widget;
  }

  static Widget userReloadWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final firebase_auth.User? user =
          firebase_auth.FirebaseAuth.instance.currentUser;

      return ElevatedButton(
        onPressed: () {
          print("ユーザリロード");
          if (user != null) {
            user.reload();
            print("user reload : ----------------- $user");
          }
        },
        child: const Text("ユーザリロード"),
      );
    });

    return widget;
  }

  static Widget verifiyEmailStateWidget() {
    final Widget widget = Consumer(builder: (context, ref, child) {
      final state = ref.watch(firebaseAuthUserStateNotifierProvider);
      final checkEmailVerified = ref.read(checkEmailVerifiedProvider);

      final firebase_auth.User? user =
          firebase_auth.FirebaseAuth.instance.currentUser;

      checkEmailVerified();
      print("state : ---------------------- $state");

      return Column(
        children: [
          Text("state : ${DateTime.now()} ${state.emailVerified}"),
          const Divider(),
          Text("user  : ${DateTime.now()} ${user}"),
        ],
      );
    });

    return widget;
  }
}
