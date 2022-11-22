import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// improve: authenticationのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../authentication/authentication.dart';

class AgoraVideoChannelJoinPageState {
  // --------------------------------------------------
  //
  //   pageTitle
  //   messageProvider
  //
  // --------------------------------------------------
  static const pageTitle = "チャンネル参加";
  static final messageProvider = StateProvider.autoDispose((ref) => "");

  // --------------------------------------------------
  //
  //  signOutIconStateProvider
  //
  // --------------------------------------------------
  static const signOutIconButtonName = "サインアウト";
  static final signOutIconStateProvider = Provider((ref) {
    //

    Function buildSignOutIconOnSubmit() {
      return ({
        required BuildContext context,
      }) =>
          () async {
            final serviceSignOutUsecase =
                ref.read(serviceSignOutUsecaseProvider);

            await serviceSignOutUsecase();
          };
    }

    final signOutIconStateProvider = appbarActionIconStateProviderCreator(
      onSubmitWidgetName: signOutIconButtonName,
      icon: const Icon(Icons.logout),
      onSubmit: buildSignOutIconOnSubmit(),
    );

    return signOutIconStateProvider;
  });
}
