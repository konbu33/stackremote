import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../domain/firebase_auth_user.dart';

final sendVerifyEmailProvider = Provider((ref) {
  void sendVerifyEmail({
    required firebase_auth.User user,
  }) {
    logger.d("start : sendVerifyEmail");
    if (!user.emailVerified) {
      user.sendEmailVerification();
      logger.d("end : sendVerifyEmail");
    }
  }

  return sendVerifyEmail;
});

final checkEmailVerifiedProvider = Provider.autoDispose((ref) {
  bool isEmailVerified = false;

  Timer checkEmailVerified() {
    return Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        // print(" ${DateTime.now()} : Timer During....................");
        // userChanges でFirebaseAuthのUserの状状変化を監視している場合
        // reload()実行するだけで、currentUserで取得できるemailVerified属性の最新の値が反映される。

        // authStateChanges でFirebaseAuthのUserの状状変化を監視している場合
        // reload()実行するだけでは、currentUserで取得できるemailVerified属性の最新の値が反映さない。
        // reload() + currentUserの取得 により、currentUserで取得できるemailVerified属性の最新の値が反映される。

        // try {
        // firebase_auth.FirebaseAuth.instance.currentUser!.reload();
        // } on firebase_auth.FirebaseAuthException catch (e) {
        //   print("e ---------------- : $e");
        // }

        final firebase_auth.User? user =
            firebase_auth.FirebaseAuth.instance.currentUser;

        if (user == null) {
          timer.cancel();
        } else {
          user.reload();
          isEmailVerified = user.emailVerified;
        }

        // if (user != null) {
        //   isEmailVerified = user.emailVerified;
        // }

        if (isEmailVerified) {
          final notifier =
              ref.watch(firebaseAuthUserStateNotifierProvider.notifier);
          notifier.updateEmailVerified(isEmailVerified);

          timer.cancel();
        }
      },
    );
  }

  return checkEmailVerified();
});
