import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../usecase/authentication_service.dart';
import 'authentication_service_state.dart';

class AuthenticationServiceFirebase
    extends StateNotifier<AuthenticationServiceState>
    implements AuthenticationService {
  AuthenticationServiceFirebase({
    required this.instance,
  }) : super(AuthenticationServiceState.create());

  final FirebaseAuth instance;

  @override
  Stream<User?> authStatusChanges() {
    final Stream<User?> res = instance.authStateChanges();
    return res;
  }

  void changeLoggedIn(bool flg) {
    state = state.copyWith(loggedIn: flg);
  }

  void toggleLoggedIn() {
    state = state.copyWith(loggedIn: !state.loggedIn);
  }

  @override
  void signUp(String email, String password) async {
    print("email : ${email}, password : ${password} ");
    final res = await instance.createUserWithEmailAndPassword(
        email: email, password: password);
    print("signUp : ${res}");
  }

  @override
  Future<void> signOut() async {
    await instance.signOut();
    print("signOut : ");
  }

  @override
  void signIn(String email, String password) async {
    print("email : ${email}, password : ${password} ");
    try {
      final res = await instance.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
