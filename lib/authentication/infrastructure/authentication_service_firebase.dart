import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../user/domain/user.dart';
import '../../user/domain/userid.dart';
import 'authentication_service.dart';

class AuthenticationServiceFirebase implements AuthenticationService {
  AuthenticationServiceFirebase({
    required this.instance,
  }) : super();

  @override
  final firebase_auth.FirebaseAuth instance;

  @override
  Stream<User> authStateChanges() async* {
    final Stream<firebase_auth.User?> resStream;

    // FirebaseAuthからUserのStreamをListen
    try {
      resStream = instance.authStateChanges();
    } on firebase_auth.FirebaseAuthException catch (_) {
      rethrow;
    }

    // 「FirebaseAuth側のUser型」から「本アプリ側のUser型」へ変換
    await for (final firebaseUser in resStream) {
      // Streamから流れてくるFirebaseのUserがnullの場合
      try {
        if (firebaseUser == null) {
          final UserId userId = UserId.create();
          final User user = User.reconstruct(
            userId: userId,
            email: "",
            password: "",
            isSignIn: false,
            firebaseAuthUid: "",
            firebaseAuthIdToken: "",
          );

          yield user;
          return;
        }
      } on firebase_auth.FirebaseAuthException catch (_) {
        rethrow;
      }

      // Streamから流れてくるFirebaseのUserのemail属性の値がnullの場合
      final firebaseAuthUid = firebaseUser.uid;
      final email = firebaseUser.email;

      try {
        if (email == null) {
          throw firebase_auth.FirebaseAuthException(code: "email is null.");
        }
      } on firebase_auth.FirebaseAuthException catch (_) {
        // final User user = User.reconstruct(
        //   userId: UserId.create(),
        //   email: "null",
        //   password: "null",
        //   firebaseAuthUid: firebaseAuthUid,
        //   firebaseAuthIdToken: "null",
        //   isSignIn: false,
        // );
        rethrow;
      }

      // Construct User Object
      final UserId userId = UserId.create();
      final User user = User.reconstruct(
        userId: userId,
        email: email,
        password: "",
        firebaseAuthUid: firebaseAuthUid,
        firebaseAuthIdToken: "",
        isSignIn: true,
      );

      yield user;
      return;
    }
  }

  @override
  Future<firebase_auth.UserCredential> signIn(
      String email, String password) async {
    // print("email : ${email}, password : ${password} ");
    try {
      final res = await instance.signInWithEmailAndPassword(
          email: email, password: password);

      await FirebaseAnalytics.instance.logEvent(
        name: 'login',
        parameters: {
          'method': 'signIn',
        },
      );

      // print("signIn : ${res}");
      return res;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // print(e);
      switch (e.code) {
        case "user-not-found":
          // [firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.
          rethrow;

        case "too-many-requests":
          // [firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.
          rethrow;

        default:
          rethrow;
      }
    }
  }

  @override
  Future<firebase_auth.UserCredential> signUp(
      String email, String password) async {
    // print("email : ${email}, password : ${password} ");
    try {
      final res = await instance.createUserWithEmailAndPassword(
          email: email, password: password);

      // print("signUp : ${res}");

      return res;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // print("e.code : ${e.code}");
      switch (e.code) {
        case "email-already-in-use":
          // FirebaseAuthException ([firebase_auth/email-already-in-use] The email address is already in use by another account.)
          rethrow;

        default:
          rethrow;
      }
    }
  }

  @override
  Future<void> signOut() async {
    await instance.signOut();
    // print("signOut : ");
  }

  @override
  Future<String> getIdToken() async {
    final currentUser = instance.currentUser;
    if (currentUser != null) {
      final idToken = await currentUser.getIdToken();
      return idToken;
    }
    return "currentUser is null.";
  }
}
