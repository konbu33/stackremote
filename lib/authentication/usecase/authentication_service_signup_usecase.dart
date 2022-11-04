import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../authentication.dart';
import '../infrastructure/authentication_service.dart';

final authenticationServiceSignUpUsecaseProvider = Provider((ref) {
  final AuthenticationService authenticationService =
      ref.read(authenticationServiceFirebaseProvider);

  return AuthenticationServiceSignUpUsecase(
      authenticationService: authenticationService);
});

class AuthenticationServiceSignUpUsecase {
  AuthenticationServiceSignUpUsecase({
    required this.authenticationService,
  });

  final AuthenticationService authenticationService;

  Future<firebase_auth.UserCredential> execute(
      String email, String password) async {
    final res = await authenticationService.signUp(email, password);
    return res;
  }
}
