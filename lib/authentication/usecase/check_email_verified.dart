import 'dart:async';

// improve: この依存を解消したい。
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../domain/firebase_auth_user.dart';
import '../infrastructure/authentication_service.dart';
import '../infrastructure/authentication_service_firebase.dart';

final checkEmailVerifiedUsecaseProvider = Provider.autoDispose((ref) {
  //

  Timer execute() {
    return Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        logger.d("checkEmailVerifiedTimer");
        // print(" ${DateTime.now()} : Timer During....................");
        // userChanges でFirebaseAuthのUserの状態変化を監視している場合
        // reload()実行するだけで、currentUserで取得できるemailVerified属性の最新の値が反映される。

        // authStateChanges でFirebaseAuthのUserの状態変化を監視している場合
        // reload()実行するだけでは、currentUserで取得できるemailVerified属性の最新の値が反映さない。
        // reload() + currentUserの取得 により、currentUserで取得できるemailVerified属性の最新の値が反映される。

        // pageでuseEffectを利用するとtry,catchして、timer.cancel()できたが、useEffect利用しない場合、
        // pageでtry,catchして、timer.cancel()できなかったため、ここでcancelする必要がありそう。
        try {
          final AuthenticationService authenticationService =
              ref.watch(authenticationServiceFirebaseProvider);

          final bool isEmailVerified =
              await authenticationService.currentUserGetEmailVerified();

          if (isEmailVerified) {
            final firebaseAuthUserStateNotifier =
                ref.watch(firebaseAuthUserStateNotifierProvider.notifier);

            firebaseAuthUserStateNotifier.updateEmailVerified(isEmailVerified);

            timer.cancel();
          }
        } on firebase_auth.FirebaseAuthException catch (e) {
          switch (e.code) {
            case "current-user-null":
              timer.cancel();

              break;

            default:
              break;
          }
        }
      },
    );
  }

  return execute;
});
