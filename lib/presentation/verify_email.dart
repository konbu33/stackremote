import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/domain/firebase_auth_user.dart';

final sendVerifyEmailProvider = Provider((ref) {
  void sendVerifyEmail({
    required firebase_auth.User user,
  }) {
    if (!user.emailVerified) {
      user.sendEmailVerification();
    }
  }

  return sendVerifyEmail;
});

final checkEmailVerifiedProvider = Provider.autoDispose((ref) {
  bool isEmailVerified = false;

  void checkEmailVerified() {
    final timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        // userChanges でFirebaseAuthのUserの状状変化を監視している場合
        // reload()実行するだけで、currentUserで取得できるemailVerified属性の最新の値が反映される。

        // authStateChanges でFirebaseAuthのUserの状状変化を監視している場合
        // reload()実行するだけでは、currentUserで取得できるemailVerified属性の最新の値が反映さない。
        // reload() + currentUserの取得 により、currentUserで取得できるemailVerified属性の最新の値が反映される。

        firebase_auth.FirebaseAuth.instance.currentUser!.reload();

        final firebase_auth.User? user =
            firebase_auth.FirebaseAuth.instance.currentUser;

        if (user != null) {
          isEmailVerified = user.emailVerified;
        }
        if (isEmailVerified) {
          final notifier =
              ref.read(firebaseAuthUserStateNotifierProvider.notifier);
          notifier.updateEmailVerified(isEmailVerified);

          timer.cancel();
        }
      },
    );
  }

  return checkEmailVerified;
});
