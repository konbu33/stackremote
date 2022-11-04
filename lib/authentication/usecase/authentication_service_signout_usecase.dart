import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../authentication.dart';
import '../infrastructure/authentication_service.dart';

final authenticationServiceSignOutUsecaseProvider = Provider((ref) {
  final AuthenticationService authenticationService =
      ref.read(authenticationServiceFirebaseProvider);

  return AuthenticationServiceSignOutUsecase(
      authenticationService: authenticationService);
});

class AuthenticationServiceSignOutUsecase {
  AuthenticationServiceSignOutUsecase({
    required this.authenticationService,
  });

  final AuthenticationService authenticationService;

  void execute() {
    authenticationService.signOut();
  }
}
