import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onboarding/onboarding.dart';

import '../page/onboarding_page_state.dart';
import 'signin_button_widget.dart';
import 'skip_button_widget.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomIndicator(
              netDragPercent: dragDistance,
              pagesLength: pagesLength,
              indicator: Indicator(
                indicatorDesign: IndicatorDesign.polygon(
                  polygonDesign: PolygonDesign(
                    polygon: DesignType.polygon_circle,
                  ),
                ),
                closedIndicator:
                    ClosedIndicator(color: Theme.of(context).primaryColor),
              ),
            ),
            index == pagesLength - 1
                ? const SignInButtonWidget()
                : SkipButtonWidget(setIndex: setIndex)
          ],
        ),
      );
    };
  }

  return footerBuilder;
});
