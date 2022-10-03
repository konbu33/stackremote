import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../infrastructure/authentication_service.dart';

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
