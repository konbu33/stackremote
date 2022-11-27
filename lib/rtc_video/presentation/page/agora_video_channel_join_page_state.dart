import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/rtc_video/usecase/channel_join.dart';

// improve: authenticationのモジュールをimportしている点、疎結合に改善可能か検討の余地あり。
import '../../../authentication/authentication.dart';
import '../widget/channel_join_submit_state.dart';
import '../widget/channel_name_field_state.dart';

class ChannelJoinProgress extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // voidの場合、初期化不要。
  }

  void channelJoin() async {
    final channelJoinUsecase = await ref.read(channelJoinUsecaseProvider);

    // まずローディング中であることを保持する。
    state = const AsyncLoading();
    // 結果を受けて、Data or Errorを保持する。
    state = await AsyncValue.guard(channelJoinUsecase);
  }
}

class AgoraVideoChannelJoinPageState {
  // --------------------------------------------------
  //
  //   pageTitle
  //   messageProvider
  //
  // --------------------------------------------------
  static const pageTitle = "チャンネル参加";
  static final messageProvider = StateProvider.autoDispose((ref) => "");

  static final channelJoinProgressProvider =
      AsyncNotifierProvider<ChannelJoinProgress, void>(() {
    return ChannelJoinProgress();
  });

  // final channelJoinUsecase = ref.watch(channelJoinUsecaseProvider);

  // final a = channelJoinUsecase.when<AsyncValue<dynamic>>(data: (data) {
  //   return AsyncValue.data(data());
  // }, error: (error, stackTrace) {
  //   // final message = "${DateTime.now()} : チャンネル参加失敗しました。";
  //   // ref
  //   //     .read(AgoraVideoChannelJoinPageState.messageProvider.notifier)
  //   //     .update((state) => message);
  //   //
  //   return AsyncValue.error(error, stackTrace);
  // }, loading: () {
  //   // final message = "${DateTime.now()} : チャンネル参加待機中です...";
  //   // ref
  //   //     .read(AgoraVideoChannelJoinPageState.messageProvider.notifier)
  //   //     .update((state) => message);
  //   //
  //   return const AsyncValue.loading();
  // });

  // return a;
  // });

  // --------------------------------------------------
  //
  //  channelNameFieldStateNotifierProvider
  //  channelJoinSubmitStateNotifierProvider
  //
  // --------------------------------------------------

  static final channelNameFieldStateNotifierProvider =
      channelNameFieldStateNotifierProviderCreator();

  static final channelJoinSubmitStateNotifierProvider =
      channelJoinSubmitStateNotifierProviderCreator();

  // --------------------------------------------------
  //
  //  signOutIconStateProvider
  //
  // --------------------------------------------------
  static const signOutIconButtonName = "サインアウト";
  static final signOutIconStateProvider = Provider((ref) {
    //

    Function buildSignOutIconOnSubmit() {
      return () async {
        final serviceSignOutUsecase = ref.read(serviceSignOutUsecaseProvider);

        await serviceSignOutUsecase();
      };
    }

    final signOutIconStateProvider = appbarActionIconStateProviderCreator(
      onSubmitWidgetName: signOutIconButtonName,
      icon: const Icon(Icons.logout),
      onSubmit: buildSignOutIconOnSubmit,
    );

    return signOutIconStateProvider;
  });
}
