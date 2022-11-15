import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class AuthenticationService {
  AuthenticationService({
    required this.firebaseAuthInstance,
  });

  final firebase_auth.FirebaseAuth firebaseAuthInstance;

  Stream<firebase_auth.User?> authStateChanges();

  Future<firebase_auth.UserCredential> signIn(String email, String password);

  Future<firebase_auth.UserCredential> signUp(String email, String password);

  Future<void> signOut();
}
