import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'channel_join_submit_state.dart';

class ChannelJoinSubmitWidget extends HookConsumerWidget {
  const ChannelJoinSubmitWidget({
    Key? key,
    required this.channelJoinSubmitStateProvider,
  }) : super(key: key);

  final ChannelJoinSubmitStateProvider channelJoinSubmitStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelJoinSubmitState = ref.watch(channelJoinSubmitStateProvider);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            )),
            onPressed: channelJoinSubmitState.onSubmit(context: context),
            child: Text(channelJoinSubmitState.channelJoinSubmitWidgetName),
          ),
        ),
      ],
    );
  }
}
