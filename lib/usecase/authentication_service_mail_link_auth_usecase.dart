import 'authentication_service.dart';

class AuthenticationServiceMailLinkAuthUsecase {
  AuthenticationServiceMailLinkAuthUsecase({
    required this.authenticationService,
  });

  final AuthenticationService authenticationService;

  void execute(String email) {
    authenticationService.mailLinkAuth(email);
  }
}
