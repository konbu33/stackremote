import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'description_message_state.dart';

class DescriptionMessageWidget extends StatelessWidget {
  const DescriptionMessageWidget({
    Key? key,
    required this.descriptionMessageStateProvider,
    this.textStyle,
  }) : super(key: key);

  final DescriptionMessageStateProvider descriptionMessageStateProvider;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final descriptionMessageState =
          ref.watch(descriptionMessageStateProvider);

      if (descriptionMessageState.message.isEmpty) return const SizedBox();

      return Column(
        children: [
          const SizedBox(height: 20),
          Text(
            descriptionMessageState.message,
            style: textStyle,
          ),
        ],
      );
    });
  }
}
