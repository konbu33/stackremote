// improve: この依存をrepositoryに閉じ込めたい
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../authentication.dart';

final authenticationServiceAuthStateChangesUsecaseProvider = Provider((ref) {
  final AuthenticationService authenticationService =
      ref.watch(authenticationServiceFirebaseProvider);

  final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);
  final notifier = ref.watch(firebaseAuthUserStateNotifierProvider.notifier);

  // improve: StreamProviderの方が良い？
  void execute() {
    final Stream<firebase_auth.User?> stream =
        authenticationService.authStateChanges();

    logger.d("authenticationServiceAuthStateChangesUsecaseProvider");

    stream.listen(
      (firebase_auth.User? fbuser) {
        final FirebaseAuthUser user;
        if (fbuser == null) {
          user = FirebaseAuthUser.reconstruct(
            isSignIn: false,
          );
        } else {
          final firebaseAuthUid = fbuser.uid;

          user = FirebaseAuthUser.reconstruct(
            email: fbuser.email ?? "",
            emailVerified: fbuser.emailVerified,
            firebaseAuthUid: firebaseAuthUid,
            isSignIn: true,
          );
        }

        if (user.isSignIn != firebaseAuthUser.isSignIn) {
          notifier.userInformationRegiser(user);
        }
      },
    );
  }

  return execute;
});
