import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infrastructure/authentication_service.dart';
import '../infrastructure/authentication_service_firebase.dart';

final currentUserSendVerifyEmailUsecaseProvider = Provider((ref) {
  //
  final AuthenticationService authenticationService =
      ref.watch(authenticationServiceFirebaseProvider);

  Future<void> execute() async {
    await authenticationService.currentUserSendEmailVerification();
  }

  return execute;
});
