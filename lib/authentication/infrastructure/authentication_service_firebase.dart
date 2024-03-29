import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';

import '../common/firebase_auth_exception_enum.dart';
import '../domain/firebase_auth_user.dart';
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
  Stream<FirebaseAuthUser> authStateChanges() {
    final stream = firebaseAuthInstance.authStateChanges();

    final streamTransformer =
        StreamTransformer<firebase_auth.User?, FirebaseAuthUser>.fromHandlers(
      handleData: (data, sink) {
        final fbuser = data;

        final FirebaseAuthUser user;

        if (fbuser == null) {
          user = FirebaseAuthUser.reconstruct(isSignIn: false);
        } else {
          // fbuser.refreshToken;
          fbuser.getIdToken();

          // currentUserRefreshToken();
          // currentUserGetIdToken();

          user = FirebaseAuthUser.reconstruct(
            email: fbuser.email ?? "",
            emailVerified: fbuser.emailVerified,
            firebaseAuthUid: fbuser.uid,
            isSignIn: true,
          );
        }

        sink.add(user);
      },
      handleError: (error, stackTrace, sink) {
        logger.d("$error, $stackTrace");
      },
      handleDone: (sink) {
        //
      },
    );

    final firebaseAuthUserStream = stream.transform(streamTransformer);
    return firebaseAuthUserStream;
  }

  // --------------------------------------------------
  //
  //   currentUserDelete
  //
  // --------------------------------------------------
  @override
  Future<void> currentUserDelete() async {
    try {
      final firebase_auth.User user = currentUserGet();

      await user.delete();
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        code: e.code,
        message: FirebaseAuthExceptionEnum.messageToJapanese(e),
        stackTrace: e.stackTrace,
      );
    }
  }

  // --------------------------------------------------
  //
  //   currentUserGet
  //
  // --------------------------------------------------
  @override
  firebase_auth.User currentUserGet() {
    try {
      final firebase_auth.User? user = firebaseAuthInstance.currentUser;

      if (user == null) {
        throw firebase_auth.FirebaseAuthException(code: "current-user-null");
      }

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        code: e.code,
        message: FirebaseAuthExceptionEnum.messageToJapanese(e),
        stackTrace: e.stackTrace,
      );
    }
  }

  // --------------------------------------------------
  //
  //   currentUserGetEmailVerified
  //
  // --------------------------------------------------
  @override
  Future<bool> currentUserGetEmailVerified() async {
    try {
      // emailのリンク押下して、メールアドレス検証完了したが、
      // currentUser.emailVerified がfalseのままで、最新の状態が反映されていなかった。
      // 最新の状態を反映するためには、currentUser.emailVerified参照前に、
      // 明示的にcurrentUser.reload() を実行しておく必要がある様子
      final firebase_auth.User user = await currentUserReload();

      return user.emailVerified;
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        code: e.code,
        message: FirebaseAuthExceptionEnum.messageToJapanese(e),
        stackTrace: e.stackTrace,
      );
    }
  }

  // --------------------------------------------------
  //
  //   currentUserGetIdToken
  //
  // --------------------------------------------------
  @override
  Future<String> currentUserGetIdToken() async {
    try {
      final firebase_auth.User user = currentUserGet();

      final newToken = await user.getIdToken();
      return newToken;

      //
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        code: e.code,
        message: FirebaseAuthExceptionEnum.messageToJapanese(e),
        stackTrace: e.stackTrace,
      );
    }
  }

  // --------------------------------------------------
  //
  //   currentUserReload
  //
  // --------------------------------------------------
  @override
  Future<firebase_auth.User> currentUserReload() async {
    try {
      final firebase_auth.User user = currentUserGet();

      await user.reload();
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        code: e.code,
        message: FirebaseAuthExceptionEnum.messageToJapanese(e),
        stackTrace: e.stackTrace,
      );
    }
  }

  // --------------------------------------------------
  //
  //   currentUserSendEmailVerification
  //
  // --------------------------------------------------
  @override
  Future<void> currentUserSendEmailVerification() async {
    try {
      final firebase_auth.User user = currentUserGet();

      if (user.emailVerified) {
        throw firebase_auth.FirebaseAuthException(
            code: "already-email-verified");
      }

      await user.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        code: e.code,
        message: FirebaseAuthExceptionEnum.messageToJapanese(e),
        stackTrace: e.stackTrace,
      );
    }
  }

  // --------------------------------------------------
  //
  //   currentUserUpdatePassword
  //
  // --------------------------------------------------
  @override
  Future<void> currentUserUpdatePassword(
    String password,
  ) async {
    try {
      final firebase_auth.User user = currentUserGet();

      await user.updatePassword(password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        code: e.code,
        message: FirebaseAuthExceptionEnum.messageToJapanese(e),
        stackTrace: e.stackTrace,
      );
    }
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

      return res;
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        code: e.code,
        message: FirebaseAuthExceptionEnum.messageToJapanese(e),
        stackTrace: e.stackTrace,
      );
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

      throw StackremoteException(
        plugin: e.plugin,
        code: e.code,
        message: FirebaseAuthExceptionEnum.messageToJapanese(e),
        stackTrace: e.stackTrace,
      );
    } on Exception catch (e, s) {
      logger.d("$e, $s");
      rethrow;
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

      throw StackremoteException(
        plugin: e.plugin,
        code: e.code,
        message: FirebaseAuthExceptionEnum.messageToJapanese(e),
        stackTrace: e.stackTrace,
      );
    }
  }
}
