import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/firebase_auth_user.dart';
import '../infrastructure/authentication_service.dart';
import '../infrastructure/authentication_service_firebase.dart';

final checkAuthStateChangesUsecaseProvider = Provider((ref) {
  final AuthenticationService authenticationService =
      ref.watch(authenticationServiceFirebaseProvider);

  // improve: StreamProviderの方が良い？
  Stream<FirebaseAuthUser> execute() {
    final Stream<FirebaseAuthUser> stream =
        authenticationService.authStateChanges();

    return stream;
  }

  return execute;
});
