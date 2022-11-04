// improve: この依存をrepositoryに閉じ込めたい
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../authentication.dart';

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

  // improve: FutureProviderの方が良い？
  Future<firebase_auth.UserCredential> execute(
      String email, String password) async {
    final res = await authenticationService.signUp(email, password);
    return res;
  }
}
