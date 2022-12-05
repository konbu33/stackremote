import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'progress_state.dart';

class ProgressWidget extends HookConsumerWidget {
  const ProgressWidget({
    super.key,
    required this.progressStateNotifierProvider,
  });

  final ProgressStateNotifierProvider progressStateNotifierProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressStateNotifierProvider);

    return progressState.when(data: (data) {
      return const SizedBox();
    }, error: (error, stackTrace) {
      return const SizedBox();
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}
