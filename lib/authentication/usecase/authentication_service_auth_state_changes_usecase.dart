import '../../user/domain/user.dart';
import '../infrastructure/authentication_service.dart';

class AuthenticationServiceAuthStateChangesUsecase {
  AuthenticationServiceAuthStateChangesUsecase({
    required this.authenticationService,
  });

  final AuthenticationService authenticationService;

  Stream<User> execute() {
    final userStream = authenticationService.authStateChanges();
    return userStream;
  }
}
