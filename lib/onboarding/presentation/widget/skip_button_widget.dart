import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onboarding/onboarding.dart';

import '../page/onboarding_page_state.dart';

class SkipButtonWidget extends ConsumerWidget {
  const SkipButtonWidget({
    super.key,
    required this.setIndex,
  });

  final void Function(int)? setIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: Theme.of(context).primaryColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            ref
                .watch(OnboardingPageState.indexProvider.notifier)
                .update((state) => 2);
            setIndex!(2);
          }
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Skip',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
