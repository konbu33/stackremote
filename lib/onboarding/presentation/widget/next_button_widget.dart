import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onboarding/onboarding.dart';

import '../page/onboarding_page_state.dart';

class NextButtonWidget extends ConsumerWidget {
  const NextButtonWidget({
    super.key,
    required this.setIndex,
  });

  final void Function(int)? setIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(OnboardingPageState.indexProvider);
    final nextPage = currentPage + 1;

    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: Theme.of(context).primaryColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            ref
                .watch(OnboardingPageState.indexProvider.notifier)
                .update((state) => nextPage);
            setIndex!(nextPage);
          }
        },
        child: Container(
          padding: defaultSkipButtonPadding,
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            minWidth: 150,
            minHeight: 50,
            maxWidth: 300,
          ),
          child: const Text(
            '次へ',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
