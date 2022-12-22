import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/common.dart';
import '../widget/progress_state_channel_join.dart';
import '../widget/progress_state_signout.dart';

class RtcVideoChannelJoinPageState {
  // --------------------------------------------------
  //
  //   pageTitle
  //   messageProvider
  //
  // --------------------------------------------------
  static const pageTitle = "チャンネル参加";
  static final attentionMessageStateProvider =
      StateProvider.autoDispose((ref) => "");

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

  // static final channelJoinSubmitStateNotifierProvider =
  //     channelJoinSubmitStateNotifierProviderCreator();

  // --------------------------------------------------
  //
  //  channelJoinProgressStateProviderOfProvider
  //
  // --------------------------------------------------
  static final channelJoinProgressStateProviderOfProvider =
      Provider.autoDispose((ref) {
    final function = ref.watch(progressStateChannelJoinProvider);

    return progressStateNotifierProviderCreator(function: function);
  });

  // --------------------------------------------------
  //
  //  signOutProgressStateNotifierProviderOfProvider
  //
  // --------------------------------------------------
  static final signOutProgressStateNotifierProviderOfProvider = Provider((ref) {
    final function = ref.watch(progressStateSignOutProvider);

    return progressStateNotifierProviderCreator(function: function);
  });

  // --------------------------------------------------
  //
  //  signOutIconStateProvider
  //
  // --------------------------------------------------
  static final signOutIconStateProvider = Provider((ref) {
    //

    AppbarActionIconOnSubmitFunction buildSignOutIconOnSubmit() {
      return ({required BuildContext context}) => () async {
            final signOutProgressStateNotifierProvider =
                ref.read(signOutProgressStateNotifierProviderOfProvider);

            ref
                .read(signOutProgressStateNotifierProvider.notifier)
                .updateProgress();
          };
    }

    final appbarActionIconState = AppbarActionIconState.create(
      onSubmitWidgetName: "サインアウト",
      icon: const Icon(Icons.logout),
      onSubmit: buildSignOutIconOnSubmit(),
    );

    final signOutIconStateProvider =
        appbarActionIconStateNotifierProviderCreator(
      appbarActionIconState: appbarActionIconState,
    );

    return signOutIconStateProvider;
  });

  // --------------------------------------------------
  //
  //  channelJoinOnSubmitButtonStateNotifierProvider
  //
  // --------------------------------------------------
  static final channelJoinOnSubmitButtonStateNotifierProvider =
      Provider.autoDispose(
    (ref) {
      bool isOnSubmitable = false;

      final channelNameFieldStateNotifierProvider =
          ref.watch(channelNameFieldStateNotifierProviderOfProvider);

      final channelNameIsValidate = ref.watch(
          channelNameFieldStateNotifierProvider
              .select((value) => value.isValidate.isValid));

      void Function()? buildChannelJoinOnSubmit() {
        if (!isOnSubmitable) {
          return null;
        }

        return () async {
          // channel参加
          final channelJoinProgressStateProvider = ref.read(
              RtcVideoChannelJoinPageState
                  .channelJoinProgressStateProviderOfProvider);

          ref.read(channelJoinProgressStateProvider.notifier).updateProgress();
        };
      }

      if (channelNameIsValidate) {
        isOnSubmitable = true;
      }

      final channelJoinOnSubmitButtonStateNotifierProvider =
          onSubmitButtonStateNotifierProviderCreator(
        onSubmitButtonWidgetName: pageTitle,
        onSubmit: buildChannelJoinOnSubmit,
      );

      return channelJoinOnSubmitButtonStateNotifierProvider;
    },
  );
}
