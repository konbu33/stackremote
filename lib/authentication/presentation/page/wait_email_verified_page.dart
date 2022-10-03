import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/presentation/page/wait_email_verified_page_state.dart';
// import 'package:stackremote/authentication/domain/firebase_auth_user.dart';
// import 'package:stackremote/authentication/usecase/verify_email.dart';

import '../../usecase/verify_email.dart';
import '../widget/appbar_action_icon_widget.dart';
import '../../../common/design/base_layout_widget.dart';

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
      body: BaseLayoutWidget(
        children: [
          Column(
            children: [
              WaitEmailVerifiedPageWidgets.messageWidget(),
              const SizedBox(height: 30),
              WaitEmailVerifiedPageWidgets.sendVerifiyEmailWidget(),
              const SizedBox(height: 30),
              WaitEmailVerifiedPageWidgets.verifiyEmailStateWidget(),
              // const SizedBox(height: 30),
              // WaitEmailVerifiedPageWidgets.userReloadWidget(),
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
          // print("メール送信");
          if (user != null) {
            sendVerifyEmail(user: user);
          }
        },
        child: const Text("メール送信"),
      );
    });

    return widget;
  }

  // static Widget userReloadWidget() {
  //   final Widget widget = Consumer(builder: (context, ref, child) {
  //     final firebase_auth.User? user =
  //         firebase_auth.FirebaseAuth.instance.currentUser;

  //     return ElevatedButton(
  //       onPressed: () {
  //         // print("ユーザリロード");
  //         if (user != null) {
  //           user.reload();
  //           // print("user reload : ----------------- $user");
  //         }
  //       },
  //       child: const Text("ユーザリロード"),
  //     );
  //   });

  //   return widget;
  // }

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
      // print("state : ---------------------- $state");

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
