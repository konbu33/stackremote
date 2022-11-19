import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infrastructure/authentication_service.dart';
import '../infrastructure/authentication_service_firebase.dart';

// improve: FutureProviderの方が良い？
final serviceSignInUsecaseProvider = Provider((ref) {
  final AuthenticationService authenticationService =
      ref.watch(authenticationServiceFirebaseProvider);

  Future<void> execute(String email, String password) async {
    await authenticationService.signIn(email, password);
  }

  return execute;
});
