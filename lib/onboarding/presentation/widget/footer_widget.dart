import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

import '../../../onboarding_layer.dart';
import '../page/onboarding_page_state.dart';
import 'indicator_widget.dart';

final setIndexProvider = StateProvider((ref) {
  void setIndex(int incex) {}

  return setIndex;
});

typedef FooterBuilder = dynamic Function(
  BuildContext,
  double,
  int,
  void Function(int),
)?;

final footerBuilderProvider = Provider((ref) {
  final index = ref.watch(OnboardingPageState.indexProvider);

  FooterBuilder footerBuilder() {
    return (
      BuildContext context,
      double dragDistance,
      int pagesLength,
      void Function(int) setIndex,
    ) {
      return Builder(builder: (context) {
        unawaited(Future(() {
          ref.read(setIndexProvider.notifier).update((state) => setIndex);
        }));

        return Container(
          padding: const EdgeInsets.all(45.0),
          constraints: const BoxConstraints(maxWidth: 450),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PageIndicatorWidget(
                count: OnboardingPageState.onBoardDataList.length,
                activePage: ref.watch(OnboardingPageState.indexProvider),
                pageIndicatorStyle: PageIndicatorStyle(
                  width: 150,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.grey,
                  activeSize: const Size(12, 12),
                  inactiveSize: const Size(8, 8),
                ),
              ),
              const SizedBox(height: 30),
              index == pagesLength - 1
                  ? FooterBuilderWidgetParts.dontonWidget()
                  : FooterBuilderWidgetParts.nextButtonWidget()
            ],
          ),
        );
      });
    };
  }

  return footerBuilder;
});

class FooterBuilderWidgetParts {
  static Widget dontonWidget() {
    //
    final widget = Consumer(builder: (context, ref, child) {
      //

      final doneButtonOnSubmitStateNotifierProvider =
          onSubmitButtonStateNotifierProviderCreator(
        onSubmitButtonWidgetName: "サインイン",
        onSubmit: () => () {
          ref.read(isOnBoardingFinishProvier.notifier).update((state) => true);
        },
      );

      return OnSubmitButtonWidget(
        onSubmitButtonStateNotifierProvider:
            doneButtonOnSubmitStateNotifierProvider,
      );
    });

    return widget;
  }

  static Widget nextButtonWidget() {
    //
    final widget = Consumer(builder: (context, ref, child) {
      //
      final currentPage = ref.watch(OnboardingPageState.indexProvider);
      final nextPage = currentPage + 1;

      final setIndex = ref.watch(setIndexProvider);

      final doneButtonOnSubmitStateNotifierProvider =
          onSubmitButtonStateNotifierProviderCreator(
        onSubmitButtonWidgetName: "次へ",
        onSubmit: () => () {
          ref
              .read(OnboardingPageState.indexProvider.notifier)
              .update((state) => nextPage);

          setIndex(nextPage);
        },
      );

      return OnSubmitButtonWidget(
        onSubmitButtonStateNotifierProvider:
            doneButtonOnSubmitStateNotifierProvider,
      );
    });

    return widget;
  }
}
