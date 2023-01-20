import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

class OnboardingPageState {
  static final indexProvider = StateProvider((ref) => 0);

  static final onBoardDataList = [
    {
      "imagePath": Assets.images.onboardingUseService.path,
      "title": "サービスの利用開始",
      "description": "自分のメールアドレスを登録することで、利用開始できます。",
    },
    {
      "imagePath": Assets.images.onboardingChannelJoin.path,
      "title": "音声・ビデオ通話の開始",
      "description":
          "同じチャンネル名に参加することで、参加者同士で音声・ビデオ通話できます。\n\n※チャンネル参加初期は、音声通話は可能ですが、ビデオはミュート状態になっています。ビデオ通話を開始するには「コントローラ」メニューからミュート解除します。",
    },
    {
      "imagePath": Assets.images.onboardingPointer.path,
      "title": "注目をポインタで指し示す",
      "description":
          "ポインタを表示・移動するには、画面を長押ししたまま、指を動かします。\nポインタを非表示にするには、ポインタのアイコンをタップします。",
    },
    {
      "imagePath": Assets.images.onboardingUserColor.path,
      "title": "色で参加者を識別",
      "description": "ポインタ等の色を変更することで、参加者を識別しやすくなります。「コントローラ」メニューから変更可能です。",
    },
  ];
}
