import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/presentation/authentication_service_firebase.dart';
import 'package:stackremote/authentication/usecase/authentication_service_auth_state_changes_usecase.dart';

import '../../domain/user.dart';

final abc = StreamProvider<User>((ref) {
  return AuthenticationServiceAuthStateChangesUsecase(
    authenticationService: AuthenticationServiceFirebase(
        instance: firebase_auth.FirebaseAuth.instance),
  ).execute();
});

class CounterState extends StateNotifier<int> {
  CounterState() : super(0);

  void increment(int n) {
    state = state + n;
  }
}

final counterProvider = StateNotifierProvider((ref) {
  return CounterState();
});

class AuthWidget extends HookConsumerWidget {
  const AuthWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = ref.watch(abc);
    // final c = ref.watch(counterProvider);
    final cn = ref.read(counterProvider.notifier);

    return Column(
      children: [
        Text(" , dataGetOK : ${DateTime.now()},}"),
        b.when(
            data: (user) {
              final c = ref.watch(counterProvider);
              return ElevatedButton(
                onPressed: () {
                  cn.increment(1);
                },
                child: Text(
                    "$c , dataGetOK : ${DateTime.now()}, User : ${user.toString()}"),
              );
            },
            error: (error, st) => Text("$error, $st"),
            loading: () {
              // print("aaaaaaaaaaaaaaaaaaaaaaaaaa");
              return Text("loading..... ${DateTime.now()}");
            }),
      ],
    );
  }
}
