import 'authentication_service.dart';

class AuthenticationServiceSignUpUsecase {
  AuthenticationServiceSignUpUsecase({
    required this.authenticationService,
  });

  final AuthenticationService authenticationService;

  void execute(String email, String password) {
    authenticationService.signUp(email, password);
  }
}
