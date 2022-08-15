import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginState {
  LoginState();

  final FirebaseAuth instance = FirebaseAuth.instance;

  final StreamController<bool> _streamController = StreamController<bool>();
  bool value = false;

  Stream<bool> get stream => _streamController.stream;

  void emit() {
    instance.authStateChanges().listen((event) {
      event == null ? this.value = false : this.value = true;
      _streamController.sink.add(this.value);
    });
  }
}

final LoginStateProvider = StateProvider<LoginState>((ref) {
  return LoginState();
});

// import 'dart:async';

// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class LoginState {
//   LoginState();

//   final StreamController<bool> _streamController = StreamController<bool>();
//   bool value = false;

//   Stream<bool> get stream => _streamController.stream;

//   void emit(bool value) {
//     this.value = value;
//     _streamController.sink.add(value);
//   }
// }

// final LoginStateProvider = StateProvider<LoginState>((ref) {
//   return LoginState();
// });
