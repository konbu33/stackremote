import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoListWidget extends HookConsumerWidget {
  const TodoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              context.push('/todolist');
            },
            child: const Text("Todo List")),
        const SizedBox(height: 40),
        GestureDetector(
            onTap: () {
              context.push('/todo/detail/nGDBI3RAGaKgyWJYK11m');
            },
            child: const Text("Todo Detail")),
      ],
    );
  }
}
