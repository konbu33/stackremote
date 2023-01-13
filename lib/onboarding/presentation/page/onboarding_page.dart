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
              PageModel(widget: OnboardingPageWidgets.startServiceUsePage()),
              PageModel(widget: OnboardingPageWidgets.startVideoPage()),
              PageModel(widget: OnboardingPageWidgets.pointerPage()),
              PageModel(widget: OnboardingPageWidgets.userColorPage()),
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
  // startServiceUsePage
  static startServiceUsePage() {
    final widget = Consumer(builder: (context, ref, child) {
      //
      final imagePath = Assets.images.backgroundImageCloudPink.path;

      const title = 'サービスの利用開始';

      const description =
          '自分のメールアドレスを登録します。\n登録したメールアドレスにメールが届きます。メール本文のリンクをクリックして、あなたが「登録したメールアドレスの持ち主」であることを証明することで、利用開始できます。';

      final descriptionWidgetState = DescriptionWidgetState.create(
        imagePath: imagePath,
        title: title,
        description: description,
      );

      return DescriptionWidget(descriptionWidgetState: descriptionWidgetState);
    });

    return widget;
  }

  // startVideoPage
  static startVideoPage() {
    final widget = Consumer(builder: (context, ref, child) {
      //
      final imagePath = Assets.images.backgroundImageCloudPink.path;

      const title = 'ビデオ通話の開始';

      const description = '同じチャンネル名に参加することで、参加者同士でビデオ通話できます。';

      final descriptionWidgetState = DescriptionWidgetState.create(
        imagePath: imagePath,
        title: title,
        description: description,
      );

      return DescriptionWidget(descriptionWidgetState: descriptionWidgetState);
    });

    return widget;
  }

  // pointerPage
  static pointerPage() {
    final widget = Consumer(builder: (context, ref, child) {
      //
      final imagePath = Assets.images.backgroundImageCloudPink.path;

      const title = '注目をポインタで指し示す';

      const description =
          'ポインタを表示・移動したい場合、画面をロングタップしたまま、ドラッグ・アンド・ドロップします。\nポインタを非表示にしたい場合，ポインタのアイコンをタップすることで非表示にできます。';

      final descriptionWidgetState = DescriptionWidgetState.create(
        imagePath: imagePath,
        title: title,
        description: description,
      );

      return DescriptionWidget(descriptionWidgetState: descriptionWidgetState);
    });

    return widget;
  }

  // userColorPage
  static userColorPage() {
    final widget = Consumer(builder: (context, ref, child) {
      //
      final imagePath = Assets.images.backgroundImageCloudPink.path;

      const title = '色を変更し、参加者を識別';

      const description =
          'ポインタや、ビデオの枠の色を変更することで、参加者を識別しやすくなります。\n例えば、「赤色のカメラ映像に切り替えて」と参加者に促すことで、参加者が同じカメラ映像を見るように促す、といった利用イメージです。';

      final descriptionWidgetState = DescriptionWidgetState.create(
        imagePath: imagePath,
        title: title,
        description: description,
      );

      return DescriptionWidget(descriptionWidgetState: descriptionWidgetState);
    });

    return widget;
  }
}
