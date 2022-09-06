import 'authentication_service.dart';

class AuthenticationServiceGetIdTokenUsecase {
  AuthenticationServiceGetIdTokenUsecase({
    required this.authenticationService,
  });

  final AuthenticationService authenticationService;

  Future<String> execute() async {
    final idToken = await authenticationService.getIdToken();
    return idToken;
  }
}
