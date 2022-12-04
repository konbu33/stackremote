import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/common/validation/validator.dart';
import 'package:stackremote/common/widget/name_field_state.dart';

// improve: authenticationのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../authentication/authentication.dart';
import '../widget/channel_join_progress_state.dart';
import '../widget/channel_join_submit_state.dart';

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
  //  channelNameFieldStateNotifierProvider
  //  channelJoinSubmitStateNotifierProvider
  //
  // --------------------------------------------------

  // static final channelNameFieldStateNotifierProvider =
  //     channelNameFieldStateNotifierProviderCreator();

  static final channelNameFieldStateNotifierProviderOfProvider =
      StateProvider((ref) {
    NameFieldStateNotifierProvider
        channelNameFieldStateNotifierProviderCreator() {
      const name = "チャンネル名";
      const minMax = MinMax(min: 0, max: 20);
      final validator = ref.watch(minMaxLenghtValidatorProvider(minMax));

      final nameFieldStateNotifierProvider =
          nameFieldStateNotifierProviderCreator(
        name: name,
        validator: validator,
        minLength: minMax.min,
        maxLength: minMax.max,
      );

      return nameFieldStateNotifierProvider;
    }

    return channelNameFieldStateNotifierProviderCreator();
  });

  static final channelJoinSubmitStateNotifierProvider =
      channelJoinSubmitStateNotifierProviderCreator();

  // --------------------------------------------------
  //
  //  channelJoinProgressStateProvider
  //
  // --------------------------------------------------
  static final channelJoinProgressStateProvider =
      channelJoinProgressStateProviderCreator();

  // --------------------------------------------------
  //
  //  signOutIconStateProvider
  //
  // --------------------------------------------------
  static final signOutIconStateProvider = Provider((ref) {
    //

    void Function() buildSignOutIconOnSubmit() {
      return () async {
        final serviceSignOutUsecase = ref.read(serviceSignOutUsecaseProvider);

        await serviceSignOutUsecase();
      };
    }

    final appbarActionIconState = AppbarActionIconState.create(
      onSubmitWidgetName: "サインアウト",
      icon: const Icon(Icons.logout),
      onSubmit: buildSignOutIconOnSubmit,
    );

    final signOutIconStateProvider =
        appbarActionIconStateNotifierProviderCreator(
      appbarActionIconState: appbarActionIconState,
    );

    return signOutIconStateProvider;
  });
}
