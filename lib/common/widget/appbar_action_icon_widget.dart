import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'appbar_action_icon_state.dart';

class AppbarAcitonIconWidget extends HookConsumerWidget {
  const AppbarAcitonIconWidget({
    Key? key,
    required this.appbarActionIconStateNotifierProvider,
  }) : super(key: key);

  final AppbarActionIconStateNotifierProvider
      appbarActionIconStateNotifierProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appbarActionIconState =
        ref.watch(appbarActionIconStateNotifierProvider);

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: IconButton(
        onPressed: appbarActionIconState.onSubmit(),
        icon: appbarActionIconState.icon,
        tooltip: appbarActionIconState.onSubmitWidgetName,
      ),
    );
  }
}
