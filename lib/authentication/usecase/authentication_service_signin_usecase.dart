import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../authentication.dart';
import '../infrastructure/authentication_service.dart';

final authenticationServiceSignInUsecaseProvider = Provider((ref) {
  final AuthenticationService authenticationService =
      ref.read(authenticationServiceFirebaseProvider);

  return AuthenticationServiceSignInUsecase(
      authenticationService: authenticationService);
});

class AuthenticationServiceSignInUsecase {
  AuthenticationServiceSignInUsecase({
    required this.authenticationService,
  });

  final AuthenticationService authenticationService;

  Future<firebase_auth.UserCredential> execute(
      String email, String password) async {
    final firebase_auth.UserCredential res =
        await authenticationService.signIn(email, password);
    return res;
  }
}
