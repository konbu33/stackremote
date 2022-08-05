import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers.dart';

class SignUpWidget extends HookConsumerWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(Providers.signUpPageNotifierProvider);
    return
        // GestureDetector(
        //   onTap: () {
        //     context.push('/signup');
        //   },
        //   child:
        Container(
      alignment: Alignment.center,
      // color: Colors.amber,
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      // child: const Text("新規登録"),
      child: IconButton(
        onPressed: () {
          context.push('/signup');
        },
        icon: Icon(Icons.person_add),
        tooltip: state.title,
      ),
      // ),
    );
  }
}
