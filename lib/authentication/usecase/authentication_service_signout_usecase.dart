import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../authentication.dart';

final authenticationServiceSignOutUsecaseProvider = Provider((ref) {
  final AuthenticationService authenticationService =
      ref.watch(authenticationServiceFirebaseProvider);

  return AuthenticationServiceSignOutUsecase(
      authenticationService: authenticationService);
});

class AuthenticationServiceSignOutUsecase {
  AuthenticationServiceSignOutUsecase({
    required this.authenticationService,
  });

  final AuthenticationService authenticationService;

  // improve: FutureProviderの方が良い？
  void execute() {
    authenticationService.signOut();
  }
}
