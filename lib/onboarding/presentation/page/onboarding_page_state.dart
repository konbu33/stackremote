import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';

class OnboardingPageState {
  static final indexProvider = StateProvider((ref) => 0);

  static final onBoardDataList = [
    {
      "imagePath": Assets.images.backgroundImageCloudPink.path,
      "title": "サービスの利用開始",
      "description":
          "自分のメールアドレスを登録します。\n登録したメールアドレスにメールが届きます。メール本文のリンクをクリックして、あなたが「登録したメールアドレスの持ち主」であることを証明することで、利用開始できます。",
    },
    {
      "imagePath": Assets.images.backgroundImageCloudPink.path,
      "title": "ビデオ通話の開始",
      "description": "同じチャンネル名に参加することで、参加者同士でビデオ通話できます。",
    },
    {
      "imagePath": Assets.images.backgroundImageCloudPink.path,
      "title": "注目をポインタで指し示す",
      "description":
          "ポインタを表示・移動したい場合、画面をロングタップしたまま、ドラッグ・アンド・ドロップします。\nポインタを非表示にしたい場合，ポインタのアイコンをタップすることで非表示にできます。",
    },
    {
      "imagePath": Assets.images.backgroundImageCloudPink.path,
      "title": "色を変更し、参加者を識別",
      "description":
          "ポインタや、ビデオの枠の色を変更することで、参加者を識別しやすくなります。\n例えば、「赤色のカメラ映像に切り替えて」と参加者に促すことで、参加者が同じカメラ映像を見るように促す、といった利用イメージです。",
    },
  ];
}
