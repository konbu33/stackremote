import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/firebase_auth_user.dart';

final authStateChangesProvider = Provider((ref) {
  final notifier = ref.read(firebaseAuthUserStateNotifierProvider.notifier);

  final stream = firebase_auth.FirebaseAuth.instance.authStateChanges();
  // final stream = firebase_auth.FirebaseAuth.instance.userChanges();
  stream.listen(
    (fbuser) {
      final FirebaseAuthUser user;
      if (fbuser == null) {
        user = FirebaseAuthUser.create(
          email: "",
          emailVerified: false,
          password: "",
          firebaseAuthUid: "",
          firebaseAuthIdToken: "",
          isSignIn: false,
        );
      } else {
        final firebaseAuthUid = fbuser.uid;

        user = FirebaseAuthUser.create(
          email: fbuser.email ?? "",
          emailVerified: fbuser.emailVerified,
          password: "",
          firebaseAuthUid: firebaseAuthUid,
          firebaseAuthIdToken: "",
          isSignIn: true,
        );
      }

      notifier.userInformationRegiser(user);
    },
  );
});
