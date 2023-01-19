import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onboarding/onboarding.dart';

import '../../../common/common.dart';

import '../widget/description_widget.dart';
import '../widget/description_widget_state.dart';
import '../widget/footer_widget.dart';
import '../widget/skip_button_widget.dart';
import 'onboarding_page_state.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DesignNestedLayer(
        child: Scaffold(
          appBar: AppBar(actions: const [
            SkipButtonWidget(buttonTitle: "スキップ"),
          ]),
          body: Onboarding(
            pages: OnboardingPageWidgets.onBoardingDataWidgetList(),
            onPageChange: (int pageIndex) {
              ref
                  .read(OnboardingPageState.indexProvider.notifier)
                  .update((state) => pageIndex);
            },
            startPageIndex: 0,
            footerBuilder: ref.watch(footerBuilderProvider)(),
          ),
        ),
      ),
    );
  }
}

class OnboardingPageWidgets {
  // onBoardingDataWidgetList
  static onBoardingDataWidgetList() {
    final onBoardDataList = OnboardingPageState.onBoardDataList;

    final onBoardingDataWidgetList = onBoardDataList.map((data) {
      //
      final descriptionWidgetState = DescriptionWidgetState.create(
        imagePath: data["imagePath"] ?? "",
        title: data["title"] ?? "",
        description: data["description"] ?? "",
      );

      return PageModel(
        widget:
            DescriptionWidget(descriptionWidgetState: descriptionWidgetState),
      );
    }).toList();

    return onBoardingDataWidgetList;
  }
}
