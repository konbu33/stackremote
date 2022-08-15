import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/domain/user.dart';
import 'package:stackremote/authentication/presentation/widget/router_widget.dart';
import 'package:stackremote/authentication/presentation/widget/signout_widget.dart';
import 'package:stackremote/user_page_state.dart';

import 'authentication/common/use_auth.dart';
import 'authentication/presentation/widget/login_state.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final Reader read = ref.read;
    // final Reader watch = ref.watch;
    final state = ref.watch(userPageStateControllerProvider);
    final notifier = ref.read(userPageStateControllerProvider.notifier);
    final authservice = ref.watch(authStateChangesStreamProvider);
    // final useAuth = ref.watch(useAuthProvider);
    // useAuth();

    final userState = ref.watch(userStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: state.pageTitleWidget,
        actions: [
          state.userAddButton,
          const SignOutWidget(),
        ],
      ),
      body: Column(
        children: [
          state.userListWidget,
          Text("User : ${userState.toJson()}"),
          // ElevatedButton(
          //   onPressed: () {
          //     final state = ref.read(LoginStateProvider);
          //     state.emit(false);
          //   },
          // child: const Text("logout"),
          // ),
          authservice.when(
            data: (user) {
              return Text("${user.toString()}");
            },
            error: (e, st) => Text("error : $e"),
            loading: () => const Text("loading"),
          )
        ],
      ),
    );
  }
}
