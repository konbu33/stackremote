import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/authentication.dart';

import '../infrastructure/authentication_service.dart';

final authenticationServiceGetIdTokenUsecaseProvider = Provider((ref) {
  final AuthenticationService authenticationService =
      ref.read(authenticationServiceFirebaseProvider);

  final notifier = ref.read(firebaseAuthUserStateNotifierProvider.notifier);

// class AuthenticationServiceGetIdTokenUsecase {
//   AuthenticationServiceGetIdTokenUsecase({
//     required this.authenticationService,
//   });

//   final AuthenticationService authenticationService;

  void execute() async {
    final idToken = await authenticationService.getIdToken();
    notifier.updateFirebaseAuthIdToken(idToken);
  }

  return execute;
});
