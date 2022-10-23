import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'appbar_action_icon_state.dart';

class AppbarAcitonIconWidget extends HookConsumerWidget {
  const AppbarAcitonIconWidget({
    Key? key,
    required this.appbarActionIconStateProvider,
  }) : super(key: key);

  final AppbarActionIconStateProvider appbarActionIconStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appbarActionIconStateProvider);

    return Builder(builder: (context) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: IconButton(
          onPressed:
              state.onSubmit == null ? null : state.onSubmit!(context: context),
          icon: state.icon,
          tooltip: state.onSubmitWidgetName,
        ),
      );
    });
  }
}
