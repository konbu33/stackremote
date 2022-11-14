import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import 'authentication_service.dart';

final authenticationServiceFirebaseProvider =
    Provider<AuthenticationService>((ref) {
  return AuthenticationServiceFirebase(
    instance: firebase_auth.FirebaseAuth.instance,
  );
});

class AuthenticationServiceFirebase implements AuthenticationService {
  AuthenticationServiceFirebase({
    required this.instance,
  }) : super();

  @override
  final firebase_auth.FirebaseAuth instance;

  // --------------------------------------------------
  //
  //   authStateChanges
  //
  // --------------------------------------------------
  @override
  Stream<firebase_auth.User?> authStateChanges() {
    final stream = firebase_auth.FirebaseAuth.instance.authStateChanges();
    // improve: この時点で、FirebaseAuthのUserからこのアプリ内のUserを生成して、returnする方が良さそう。
    return stream;
  }

  // --------------------------------------------------
  //
  //   signIn
  //
  // --------------------------------------------------
  @override
  Future<firebase_auth.UserCredential> signIn(
      String email, String password) async {
    try {
      final res = await instance.signInWithEmailAndPassword(
          email: email, password: password);

      await FirebaseAnalytics.instance.logEvent(
        name: 'login',
        parameters: {
          'method': 'signIn',
        },
      );

      return res;
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");
      switch (e.code) {
        case "user-not-found":
          rethrow;

        case "too-many-requests":
          rethrow;

        default:
          rethrow;
      }
    }
  }

  // --------------------------------------------------
  //
  //   signUp
  //
  // --------------------------------------------------
  @override
  Future<firebase_auth.UserCredential> signUp(
      String email, String password) async {
    try {
      final res = await instance.createUserWithEmailAndPassword(
          email: email, password: password);

      return res;
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");
      switch (e.code) {
        case "email-already-in-use":
          rethrow;

        default:
          rethrow;
      }
    }
  }

  // --------------------------------------------------
  //
  //   signOut
  //
  // --------------------------------------------------
  @override
  Future<void> signOut() async {
    try {
      await instance.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");
      switch (e.code) {
        default:
          rethrow;
      }
    }
  }
}
