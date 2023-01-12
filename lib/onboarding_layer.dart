import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'authentication_layer.dart';
import 'onboarding/onboarding.dart';

final isOnBoardingFinishProvier = StateProvider((ref) => false);

class OnBoardingLayer extends StatelessWidget {
  const OnBoardingLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final isOnBoardingFinish = ref.watch(isOnBoardingFinishProvier);

      return isOnBoardingFinish
          ? const AuthenticationLayer()
          : const OnboardingPage();

      //
    });
  }
}
