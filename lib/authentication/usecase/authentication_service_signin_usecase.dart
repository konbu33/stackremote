// improve: この依存をrepositoryに閉じ込めたい
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../authentication.dart';

final authenticationServiceSignInUsecaseProvider = Provider((ref) {
  final AuthenticationService authenticationService =
      ref.watch(authenticationServiceFirebaseProvider);

  return AuthenticationServiceSignInUsecase(
      authenticationService: authenticationService);
});

class AuthenticationServiceSignInUsecase {
  AuthenticationServiceSignInUsecase({
    required this.authenticationService,
  });

  final AuthenticationService authenticationService;

  // improve: FutureProviderの方が良い？
  Future<firebase_auth.UserCredential> execute(
      String email, String password) async {
    final firebase_auth.UserCredential res =
        await authenticationService.signIn(email, password);
    return res;
  }
}
