import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'user_detail_page_state.dart';

class UserDetailPage extends HookConsumerWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userDetailPageStateControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: state.pageTitleWidget,
      ),
      body: Form(
        key: state.userPageformValueKey,
        child: Column(
          children: [
            const SizedBox(height: 40),
            state.userNameField,
            const SizedBox(height: 40),
            state.passwordField,
            const SizedBox(height: 40),
            state.currentUser == null
                ? state.userAddButton
                : state.userUpdateButton,
          ],
        ),
      ),
    );
  }
}
