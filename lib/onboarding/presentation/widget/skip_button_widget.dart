import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onboarding/onboarding.dart';

import '../../../onboarding_layer.dart';

class SkipButtonWidget extends ConsumerWidget {
  const SkipButtonWidget({
    super.key,
    required this.buttonTitle,
  });

  final String buttonTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          ref.read(isOnBoardingFinishProvier.notifier).update((state) => true);
        },
        child: Container(
          padding: defaultProceedButtonPadding,
          alignment: Alignment.center,
          child: Text(
            buttonTitle,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
