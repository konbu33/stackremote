import '../../infrastructure/authentication_service_if.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers.dart';
import '../../application/state/authentication_service_state.dart';

class LoggedInToggleWidget extends HookConsumerWidget {
  const LoggedInToggleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthenticationServiceState state =
        ref.watch(Providers.authenticationServiceProvider);
    final AuthenticationServiceIF notifier =
        ref.read(Providers.authenticationServiceProvider.notifier);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            notifier.toggleLoggedIn();
          },
          child: Text("toggle loggedIn : ${state.loggedIn}"),
        ),
      ],
    );
  }
}
