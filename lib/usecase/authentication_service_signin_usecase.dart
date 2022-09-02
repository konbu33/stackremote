import 'authentication_service.dart';

class AuthenticationServiceSignInUsecase {
  AuthenticationServiceSignInUsecase({
    required this.authenticationService,
  });

  final AuthenticationService authenticationService;

  void execute(String email, String password) {
    authenticationService.signIn(email, password);
  }
}
