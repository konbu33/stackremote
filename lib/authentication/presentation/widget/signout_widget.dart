import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers.dart';
import '../../application/state/signout_state.dart';
import '../../infrastructure/authentication_service_if.dart';

class SignOutWidget extends HookConsumerWidget {
  const SignOutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SignOutState state = ref.watch(Providers.signOutStateProvider);
    final AuthenticationServiceIF notifier =
        ref.watch(Providers.authenticationServiceProvider.notifier);

    return
        // GestureDetector(
        //   onTap: () {
        //     // context.push('/signup');
        //     notifier.signOut();
        //   },
        //   child:
        Container(
      alignment: Alignment.center,
      // color: Colors.amber,
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      // child: Text(state.signOutButtonName),
      child: IconButton(
          onPressed: () {
            notifier.signOut();
          },
          icon: Icon(Icons.logout),
          tooltip: state.signOutButtonName),
      // ),
    );
  }
}
