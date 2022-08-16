import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'authentication/presentation/widget/signout_widget.dart';
import 'user_page_state.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userPageStateControllerProvider);

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
        ],
      ),
    );
  }
}
