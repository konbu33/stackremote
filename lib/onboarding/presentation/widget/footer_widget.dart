import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/onboarding/presentation/widget/indicator_widget.dart';

import '../page/onboarding_page_state.dart';
import 'done_button_widget.dart';
import 'next_button_widget.dart';

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
      return Padding(
        padding: const EdgeInsets.all(45.0),
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
                ? const DoneButtonWidget(buttonTitle: "サインイン")
                : NextButtonWidget(setIndex: setIndex)
          ],
        ),
      );
    };
  }

  return footerBuilder;
});
