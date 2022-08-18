import '../domain/user.dart';
import 'authentication_service.dart';

class AuthenticationServiceAuthStateChangesUsecase {
  AuthenticationServiceAuthStateChangesUsecase({
    required this.authenticationService,
  });

  late AuthenticationService authenticationService;

  Stream<User> execute() {
    final userStream =
        authenticationService.authStateChanges().asBroadcastStream();
    userStream.listen((user) {
      // print(
      //     " AuthenticationServiceAuthStatusChangesUsecase : ${user.toJson()}");
    });
    return userStream;
  }
}
