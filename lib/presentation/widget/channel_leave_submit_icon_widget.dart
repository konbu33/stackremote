import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'channel_leave_submit_icon_state.dart';

class ChannelLeaveSubmitIconWidget extends HookConsumerWidget {
  const ChannelLeaveSubmitIconWidget({
    Key? key,
    required this.channelLeaveSubmitIconStateProvider,
  }) : super(key: key);

  final ChannelLeaveSubmitIconStateProvider channelLeaveSubmitIconStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(channelLeaveSubmitIconStateProvider);

    return Builder(builder: (context) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: IconButton(
          onPressed: state.onSubmit(context: context),
          icon: state.icon,
          tooltip: state.onSubmitWidgetName,
        ),
      );
    });
  }
}
