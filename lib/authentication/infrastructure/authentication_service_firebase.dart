// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import 'authentication_service.dart';

final firebaseAuthInstanceProvider = Provider((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

final authenticationServiceFirebaseProvider =
    Provider<AuthenticationService>((ref) {
  final firebaseAuthInstance = ref.watch(firebaseAuthInstanceProvider);
  return AuthenticationServiceFirebase(
    firebaseAuthInstance: firebaseAuthInstance,
  );
});

class AuthenticationServiceFirebase implements AuthenticationService {
  AuthenticationServiceFirebase({
    required this.firebaseAuthInstance,
  }) : super();

  @override
  final firebase_auth.FirebaseAuth firebaseAuthInstance;

  // --------------------------------------------------
  //
  //   authStateChanges
  //
  // --------------------------------------------------
  @override
  Stream<firebase_auth.User?> authStateChanges() {
    final stream = firebaseAuthInstance.authStateChanges();
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
      final res = await firebaseAuthInstance.signInWithEmailAndPassword(
          email: email, password: password);

      // improve: FirebaseAnalyticsのコードは分離した方がテストしやすいと感じている。
      // await FirebaseAnalytics.instance.logEvent(
      //   name: 'login',
      //   parameters: {
      //     'method': 'signIn',
      //   },
      // );

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
      final res = await firebaseAuthInstance.createUserWithEmailAndPassword(
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
      await firebaseAuthInstance.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");
      switch (e.code) {
        default:
          rethrow;
      }
    }
  }
}
