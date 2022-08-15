import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../domain/user.dart';
import '../domain/userid.dart';
import '../usecase/authentication_service.dart';

class AuthenticationServiceFirebase implements AuthenticationService {
  AuthenticationServiceFirebase({
    required this.instance,
  }) : super();

  final firebase_auth.FirebaseAuth instance;

  // final firebase_auth.FirebaseAuth instance2 =
  //     firebase_auth.FirebaseAuth.instance;

  @override
  Stream<User> authStateChanges() async* {
    final Stream<firebase_auth.User?> resStream;

    // FirebaseAuthからUserのStreamをListen
    try {
      resStream = instance.authStateChanges();
    } on firebase_auth.FirebaseAuthException catch (e) {
      rethrow;
    }

    // 「FirebaseAuth側のUser型」から「本アプリ側のUser型」へ変換
    await for (final firebaseUser in resStream) {
      // Streamから流れてくるFirebaseのUserがnullの場合
      try {
        if (firebaseUser == null) {
          final UserId userId = UserId.create(value: "");
          final User user =
              User.reconstruct(userId: userId, email: "", isSignIn: false);

          yield user;
          return;
        }
      } on firebase_auth.FirebaseAuthException catch (e) {
        rethrow;
      }

      // Streamから流れてくるFirebaseのUserのemail属性の値がnullの場合
      final email = firebaseUser.email;
      try {
        if (email == null) {
          throw firebase_auth.FirebaseAuthException(code: "email is null.");
        }
      } on firebase_auth.FirebaseAuthException catch (e) {
        final User user = User.reconstruct(
            userId: UserId.create(value: "null"),
            email: "null",
            isSignIn: false);
        rethrow;
      }

      // Construct User Object
      final UserId userId = UserId.create(value: firebaseUser.uid);
      final User user =
          User.reconstruct(userId: userId, email: email, isSignIn: true);

      yield user;
      return;
    }
  }

  @override
  void signIn(String email, String password) async {
    print("email : ${email}, password : ${password} ");
    try {
      final res = await instance.signInWithEmailAndPassword(
          email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  void signUp(String email, String password) async {
    print("email : ${email}, password : ${password} ");
    final res = await instance.createUserWithEmailAndPassword(
        email: email, password: password);
    print("signUp : ${res}");
  }

  @override
  Future<void> signOut() async {
    await instance.signOut();
    print("signOut : ");
  }
}



// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../usecase/authentication_service.dart';
// import 'authentication_service_state.dart';

// class AuthenticationServiceFirebase
//     extends StateNotifier<AuthenticationServiceState>
//     implements AuthenticationService {
//   AuthenticationServiceFirebase({
//     required this.instance,
//   }) : super(AuthenticationServiceState.create());

//   final FirebaseAuth instance;

//   @override
//   Stream<User?> authStatuChanges() {
//     final Stream<User?> res = instance.authStateChanges();
//     return res;
//   }

//   void changeLoggedIn(bool flg) {
//     state = state.copyWith(loggedIn: flg);
//   }

//   @override
//   void signUp(String email, String password) async {
//     print("email : ${email}, password : ${password} ");
//     final res = await instance.createUserWithEmailAndPassword(
//         email: email, password: password);
//     print("signUp : ${res}");
//   }

//   @override
//   Future<void> signOut() async {
//     await instance.signOut();
//     print("signOut : ");
//   }

//   @override
//   void signIn(String email, String password) async {
//     print("email : ${email}, password : ${password} ");
//     try {
//       final res = await instance.signInWithEmailAndPassword(
//           email: email, password: password);
//     } on FirebaseAuthException catch (e) {
//       print(e);
//     }
//   }
// }
