import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onboarding/onboarding.dart';

import 'description_widget_state.dart';

class DescriptionWidget extends ConsumerWidget {
  const DescriptionWidget({
    super.key,
    required this.descriptionWidgetState,
  });

  final DescriptionWidgetState descriptionWidgetState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 45.0,
            vertical: 90.0,
          ),
          child: Image.asset(
            descriptionWidgetState.imagePath,
            color: pageImageColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              descriptionWidgetState.title,
              style: const TextStyle(fontSize: 23),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              descriptionWidgetState.description,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}
