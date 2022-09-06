import 'authentication_service.dart';

class AuthenticationServiceSignOutUsecase {
  AuthenticationServiceSignOutUsecase({
    required this.authenticationService,
  });

  final AuthenticationService authenticationService;

  void execute() {
    authenticationService.signOut();
  }
}
