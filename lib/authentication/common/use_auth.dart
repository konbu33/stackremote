import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../presentation/authentication_service_firebase.dart';
import '../presentation/authentication_service_state.dart';

final authenticationServiceProvider = StateNotifierProvider<
    AuthenticationServiceFirebase, AuthenticationServiceState>((ref) {
  return AuthenticationServiceFirebase(instance: FirebaseAuth.instance);
});

final useAuthProvider = Provider.autoDispose((ref) {
  print(" ---------------- call useAuthProvider ------------------------- ");
  void useAuth() {
    final state = ref.watch(authenticationServiceProvider);

    final notifier = ref.read(authenticationServiceProvider.notifier);

    useEffect(() {
      notifier.authStatusChanges().listen((event) {
        print("useAuthProvider auth event : ${event}");
        if (event == null && state.loggedIn) {
          notifier.changeLoggedIn(false);
        } else if (event != null && !state.loggedIn) {
          notifier.changeLoggedIn(true);
        }
      });
    }, []);
  }

  return useAuth;
});
