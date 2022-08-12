import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationService {
  AuthenticationService({
    required this.instance,
  });

  final FirebaseAuth instance;

  Stream<User?> authStatusChanges();

  void signUp(String email, String password);

  Future<void> signOut();

  void signIn(String email, String password);
  void toggleLoggedIn();
}
