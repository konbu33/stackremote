import 'authentication_service.dart';

class AuthenticationServiceSignOutUsecase {
  AuthenticationServiceSignOutUsecase({
    required this.authenticationService,
  });

  late AuthenticationService authenticationService;

  void execute() {
    authenticationService.signOut();
  }
}
