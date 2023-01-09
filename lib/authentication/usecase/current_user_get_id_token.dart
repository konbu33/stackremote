import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infrastructure/authentication_service.dart';
import '../infrastructure/authentication_service_firebase.dart';

final currentUserGetIdTokenUsecaseProvider = Provider((ref) {
  //
  final AuthenticationService authenticationService =
      ref.watch(authenticationServiceFirebaseProvider);

  Future<String> execute() async {
    final token = await authenticationService.currentUserGetIdToken();

    return token;
  }

  return execute;
});
