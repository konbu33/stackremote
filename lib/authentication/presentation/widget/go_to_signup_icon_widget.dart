import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GoToSignUpWidget extends HookConsumerWidget {
  const GoToSignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(builder: (context) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: IconButton(
          onPressed: () {
            context.push('/signup');
          },
          icon: const Icon(Icons.person_add),
          tooltip: "新規登録",
        ),
      );
    });
  }
}
