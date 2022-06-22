import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationServiceIF {
  AuthenticationServiceIF();

  Stream<User?> authStatusChanges();

  void signUp(String email, String password);

  Future<void> signOut();

  void signIn(String email, String password);
  void toggleLoggedIn();
}
