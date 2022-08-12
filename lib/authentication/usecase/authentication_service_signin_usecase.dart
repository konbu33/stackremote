import 'package:stackremote/authentication/usecase/authentication_service.dart';

class AuthenticationServiceSignInUsecase {
  AuthenticationServiceSignInUsecase({
    required this.authenticationService,
  });

  late AuthenticationService authenticationService;

  void execute(String email, String password) {
    authenticationService.signIn(email, password);
  }
}
