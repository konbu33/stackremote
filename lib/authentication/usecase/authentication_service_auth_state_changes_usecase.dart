import 'package:stackremote/authentication/usecase/authentication_service.dart';

import '../domain/user.dart';

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
