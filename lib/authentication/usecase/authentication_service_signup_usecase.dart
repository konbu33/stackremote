import 'authentication_service.dart';

class AuthenticationServiceSignUpUsecase {
  AuthenticationServiceSignUpUsecase({
    required this.authenticationService,
  });

  late AuthenticationService authenticationService;

  void execute(String email, String password) {
    authenticationService.signUp(email, password);
  }
}
