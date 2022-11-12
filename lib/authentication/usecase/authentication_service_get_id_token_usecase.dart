import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../authentication.dart';

final authenticationServiceGetIdTokenUsecaseProvider = Provider((ref) {
  final AuthenticationService authenticationService =
      ref.watch(authenticationServiceFirebaseProvider);

  final notifier = ref.watch(firebaseAuthUserStateNotifierProvider.notifier);

  // improve: FutureProviderの方が良い？
  void execute() async {
    final idToken = await authenticationService.getIdToken();
    notifier.updateFirebaseAuthIdToken(idToken);
  }

  return execute;
});
