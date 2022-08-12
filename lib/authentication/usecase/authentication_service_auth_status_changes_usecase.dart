import 'package:firebase_auth/firebase_auth.dart';
import 'package:stackremote/authentication/usecase/authentication_service.dart';

class AuthenticationServiceSignInUsecase {
  AuthenticationServiceSignInUsecase({
    required this.authenticationService,
  });

  late AuthenticationService authenticationService;

  Stream<User?> execute() {
    return authenticationService.authStatusChanges();
  }
}
