import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'signout_icon_state.dart';

class SignOutIconWidget extends HookConsumerWidget {
  const SignOutIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signOutStateProvider);

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: IconButton(
        onPressed: () {
          state.signOut();
        },
        icon: const Icon(Icons.logout),
        tooltip: state.signOutWidgetName,
      ),
    );
  }
}
