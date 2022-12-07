import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../authentication.dart';

abstract class AuthenticationService {
  AuthenticationService({
    required this.firebaseAuthInstance,
  });

  final firebase_auth.FirebaseAuth firebaseAuthInstance;

  Stream<FirebaseAuthUser> authStateChanges();

  Future<void> currentUserDelete();
  firebase_auth.User currentUserGet();
  Future<bool> currentUserGetEmailVerified();
  Future<firebase_auth.User> currentUserReload();
  Future<void> currentUserSendEmailVerification();
  Future<void> currentUserUpdatePassword(String password);

  Future<firebase_auth.UserCredential> signIn(String email, String password);

  Future<firebase_auth.UserCredential> signUp(String email, String password);

  Future<void> signOut();
}
