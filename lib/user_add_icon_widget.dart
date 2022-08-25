import 'package:flutter/material.dart';

import 'user_detail_page.dart';

class UserAddIconWidget extends StatelessWidget {
  const UserAddIconWidget({
    Key? key,
    required this.state,
    required this.notifier,
  }) : super(key: key);

  final state;
  final notifier;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        // ModalBottomSheet処理内でのonSubmit処理を最終確定
        notifier.setUserAddOnSubmit();

        // 初期化処理
        notifier.clearUserEmailAndPassword();

        // ModalBottomSheetでの処理
        await showModalBottomSheet(
          context: context,
          builder: (context) {
            return const UserDetailPage();
          },
        );

        // 初期化処理
        notifier.clearUserEmailAndPassword();
      },
      icon: const Icon(Icons.person_add),
      tooltip: state.userAddButtonName,
    );
  }
}
