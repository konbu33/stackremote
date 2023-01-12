import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onboarding/onboarding.dart';
import 'package:stackremote/onboarding_layer.dart';

class SignUpButtonWidget extends ConsumerWidget {
  const SignUpButtonWidget({super.key});

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
        child: const Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            'Sign up',
            style: defaultProceedButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
