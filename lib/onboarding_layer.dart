import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'authentication_layer.dart';
import 'common/common.dart';
import 'onboarding/onboarding.dart';

final isOnBoardingFinishProvier = StateProvider.autoDispose((ref) {
  //
  final getBoolUsecase = ref.watch(getBoolUsecaseProvider);

  final isOnBoardingFinish = getBoolUsecase(key: 'isOnBoardingFinish');
  logger
      .d("isOnBoardingFinishProvier: isOnBoardingFinish: $isOnBoardingFinish");

  return isOnBoardingFinish ?? false;
});

final reflectIsOnBoardingFinishProvier = Provider.autoDispose((ref) async {
  final isOnBoardingFinish = ref.watch(isOnBoardingFinishProvier);

  logger.d(
      "reflectIsOnBoardingFinishProvier: isOnBoardingFinish: $isOnBoardingFinish");

  final setBoolUsecase = ref.watch(setBoolUsecaseProvider);
  await setBoolUsecase(key: 'isOnBoardingFinish', value: isOnBoardingFinish);
});

class OnBoardingLayer extends StatelessWidget {
  const OnBoardingLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final isOnBoardingFinish = ref.watch(isOnBoardingFinishProvier);

      ref.watch(reflectIsOnBoardingFinishProvier);

      return isOnBoardingFinish
          ? const AuthenticationLayer()
          : const OnboardingPage();

      //
    });
  }
}
