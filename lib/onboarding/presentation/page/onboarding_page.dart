import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onboarding/onboarding.dart';

import '../../../common/common.dart';

import '../widget/description_widget.dart';
import '../widget/description_widget_state.dart';
import '../widget/footer_widget.dart';
import 'onboarding_page_state.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DesignNestedLayer(
        child: Scaffold(
          body: Onboarding(
            pages: [
              PageModel(widget: OnboardingPageWidgets.firstPage()),
              PageModel(widget: OnboardingPageWidgets.secondPage()),
              PageModel(widget: OnboardingPageWidgets.thirdPage()),
            ],
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
  // firstPage
  static firstPage() {
    final widget = Consumer(builder: (context, ref, child) {
      final descriptionWidgetState = DescriptionWidgetState.create(
        imagePath: Assets.images.backgroundImageCloudPink.path,
        title: 'SECURED BACKUP',
        description:
            'Keep your files in closed safe so you can\'t lose them. Consider TrueNAS.',
      );

      return DescriptionWidget(descriptionWidgetState: descriptionWidgetState);
    });

    return widget;
  }

  // secondPage
  static secondPage() {
    final widget = Consumer(builder: (context, ref, child) {
      final descriptionWidgetState = DescriptionWidgetState.create(
        imagePath: Assets.images.backgroundImageCloudWhite.path,
        title: 'CHANGE AND RISE',
        description: 'Give others access to any file or folders you choose',
      );

      return DescriptionWidget(descriptionWidgetState: descriptionWidgetState);
    });

    return widget;
  }

  // thirdPage
  static thirdPage() {
    final widget = Consumer(builder: (context, ref, child) {
      final descriptionWidgetState = DescriptionWidgetState.create(
        imagePath: Assets.images.backgroundImageFigma.path,
        title: 'EASY ACCESS',
        description: 'Reach your files anytime from any devices anywhere',
      );

      return DescriptionWidget(descriptionWidgetState: descriptionWidgetState);
    });

    return widget;
  }
}
