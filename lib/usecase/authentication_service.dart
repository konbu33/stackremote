import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../domain/user.dart';

abstract class AuthenticationService {
  AuthenticationService({
    required this.instance,
  });

  final instance;

  Stream<User> authStateChanges();

  void signUp(String email, String password);

  Future<void> signOut();

  Future<firebase_auth.UserCredential> signIn(String email, String password);

  Future<String> getIdToken();

  Future<void> mailLinkAuth(String email);
}
