import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onboarding/onboarding.dart';

import '../../../onboarding_layer.dart';

class DoneButtonWidget extends ConsumerWidget {
  const DoneButtonWidget({
    super.key,
    required this.buttonTitle,
  });

  final String buttonTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: Theme.of(context).primaryColor,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {
          ref.read(isOnBoardingFinishProvier.notifier).update((state) => true);
        },
        child: Container(
          padding: defaultProceedButtonPadding,
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            minWidth: 150,
            minHeight: 50,
            maxWidth: 300,
          ),
          child: Text(
            buttonTitle,
            style: defaultProceedButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
