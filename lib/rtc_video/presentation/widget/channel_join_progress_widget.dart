import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'channel_join_progress_state.dart';

class ChannelJoinProgressWidget extends HookConsumerWidget {
  const ChannelJoinProgressWidget({
    super.key,
    required this.channelJoinProgressStateProvider,
  });

  final ChannelJoinProgressStateProvider channelJoinProgressStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelJoinProgressState =
        ref.watch(channelJoinProgressStateProvider);

    return channelJoinProgressState.when(data: (data) {
      return const SizedBox();
    }, error: (error, stackTrace) {
      return const SizedBox();
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}
