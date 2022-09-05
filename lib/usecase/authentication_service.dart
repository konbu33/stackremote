import '../domain/user.dart';

abstract class AuthenticationService {
  AuthenticationService({
    required this.instance,
  });

  final instance;

  Stream<User> authStateChanges();

  void signUp(String email, String password);

  Future<void> signOut();

  void signIn(String email, String password);

  Future<String> getIdToken();
}
