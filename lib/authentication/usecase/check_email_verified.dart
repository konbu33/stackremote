import 'dart:async';

// improve: この依存を解消したい。
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/firebase_auth_user.dart';
import '../infrastructure/authentication_service.dart';
import '../infrastructure/authentication_service_firebase.dart';

final checkEmailVerifiedUsecaseProvider = Provider.autoDispose((ref) {
  //
  bool isEmailVerified = false;

  final AuthenticationService authenticationService =
      ref.watch(authenticationServiceFirebaseProvider);

  Timer execute() {
    return Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        // print(" ${DateTime.now()} : Timer During....................");
        // userChanges でFirebaseAuthのUserの状態変化を監視している場合
        // reload()実行するだけで、currentUserで取得できるemailVerified属性の最新の値が反映される。

        // authStateChanges でFirebaseAuthのUserの状態変化を監視している場合
        // reload()実行するだけでは、currentUserで取得できるemailVerified属性の最新の値が反映さない。
        // reload() + currentUserの取得 により、currentUserで取得できるemailVerified属性の最新の値が反映される。

        isEmailVerified =
            await authenticationService.currentUserGetEmailVerified();

        if (isEmailVerified) {
          final notifier =
              ref.watch(firebaseAuthUserStateNotifierProvider.notifier);

          notifier.updateEmailVerified(isEmailVerified);

          timer.cancel();
        }
      },
    );
  }

  return execute;
});
