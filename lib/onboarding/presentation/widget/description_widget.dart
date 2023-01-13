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
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: 45.0,
            vertical: 90.0,
          ),
          child: Image.asset(
            descriptionWidgetState.imagePath,
            color: pageImageColor,
          ),
        ),
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          alignment: Alignment.centerLeft,
          child: Text(
            descriptionWidgetState.title,
            style: const TextStyle(fontSize: 23, letterSpacing: 1.0),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
            padding:
                const EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
            alignment: Alignment.topLeft,
            child: Text(
              descriptionWidgetState.description,
              textAlign: TextAlign.left,
              style: const TextStyle(letterSpacing: 1.0),
            ),
          ),
        ),
      ],
    );
  }
}
