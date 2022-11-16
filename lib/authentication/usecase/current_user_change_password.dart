import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infrastructure/authentication_service.dart';
import '../infrastructure/authentication_service_firebase.dart';

final currentUserChangePasswordUsecaseProvider = Provider((ref) {
  //
  final AuthenticationService authenticationService =
      ref.watch(authenticationServiceFirebaseProvider);

  Future<void> execute({
    required String password,
  }) async {
    await authenticationService.currentUserUpdatePassword(password);
  }

  return execute;
});
