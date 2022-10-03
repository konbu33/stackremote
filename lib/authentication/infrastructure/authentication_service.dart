import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../user/domain/user.dart';

abstract class AuthenticationService {
  AuthenticationService({
    required this.instance,
  });

  final firebase_auth.FirebaseAuth instance;

  Stream<User> authStateChanges();

  Future<firebase_auth.UserCredential> signUp(String email, String password);

  Future<void> signOut();

  Future<firebase_auth.UserCredential> signIn(String email, String password);

  Future<String> getIdToken();
}
