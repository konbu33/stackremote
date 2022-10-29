import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../authentication/authentication.dart';
import '../../../channel/channel.dart';
import '../../../user/user.dart';

import '../../domain/rtc_channel_state.dart';
import '../../infrastructure/rtc_channel_join_provider.dart';
import '../../infrastructure/rtc_token_create_provider.dart';

import 'channel_name_field_state.dart';

part 'channel_join_submit_state.freezed.dart';

// --------------------------------------------------
//
// Freezed
//
// --------------------------------------------------
@freezed
class ChannelJoinSubmitState with _$ChannelJoinSubmitState {
  const factory ChannelJoinSubmitState._({
    required String channelJoinSubmitWidgetName,
    required Function onSubmit,
  }) = _ChannelJoinSubmitState;

  factory ChannelJoinSubmitState.create({
    required String channelJoinSubmitWidgetName,
    required Function onSubmit,
  }) =>
      ChannelJoinSubmitState._(
        channelJoinSubmitWidgetName: channelJoinSubmitWidgetName,
        onSubmit: onSubmit,
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class ChannelJoinSubmitStateNotifier
    extends StateNotifier<ChannelJoinSubmitState> {
  ChannelJoinSubmitStateNotifier({
    required String channelJoinSubmitWidgetName,
    required Function onSubmit,
  }) : super(ChannelJoinSubmitState.create(
          channelJoinSubmitWidgetName: channelJoinSubmitWidgetName,
          onSubmit: onSubmit,
        ));
}

// --------------------------------------------------
//
// typedef Provider
//
// --------------------------------------------------
typedef ChannelJoinSubmitStateProvider = StateNotifierProvider<
    ChannelJoinSubmitStateNotifier, ChannelJoinSubmitState>;

// --------------------------------------------------
//
// StateNotifierProviderCreator
//
// --------------------------------------------------
ChannelJoinSubmitStateProvider channelJoinSubmitStateNotifierProviderCreator() {
  return StateNotifierProvider<ChannelJoinSubmitStateNotifier,
      ChannelJoinSubmitState>(
    (ref) {
      Function? onSubmit({required BuildContext context}) {
        final state = ref.watch(ChannelNameFieldStateNotifierProviderList
            .channelNameFieldStateNotifierProvider);

        return state.channelNameIsValidate.isValid == false
            ? null
            : () async {
                // --------------------------------------------------
                //
                // チャンネル名をアプリ内で状態として保持する
                //
                // --------------------------------------------------
                final notifier = ref.read(RtcChannelStateNotifierProviderList
                    .rtcChannelStateNotifierProvider.notifier);

                final channelName = state.channelNameFieldController.text;

                notifier.updateChannelName(channelName);

                // --------------------------------------------------
                //
                // rtc_id_token取得
                //
                // --------------------------------------------------
                final rtcCreateToken = ref.watch(rtcTokenCreateOnCallProvider);

                try {
                  await rtcCreateToken();
                } on FirebaseFunctionsException catch (error) {
                  final snackBar = SnackBar(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 50),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.cyan,
                    duration: const Duration(seconds: 5),
                    content: Text(
                      "ERROR : ${error.message}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

                // --------------------------------------------------
                //
                // チャンネル参加
                //
                // --------------------------------------------------
                final rtcJoinChannel = ref.watch(rtcJoinChannelProvider);
                await rtcJoinChannel();

                // --------------------------------------------------
                //
                // DBにチャンネル情報とユーザ情報を登録
                //
                // --------------------------------------------------
                final channelGetUsecase = ref.read(channelGetUsecaseProvider);
                final channel = await channelGetUsecase();

                final channelSetUsecase = ref.read(channelSetUsecaseProvider);
                final userSetUsecase = ref.read(userSetUsecaseProvider);

                // 本アプリのカレントユーザのemailを取得
                final firebaseAuthUser =
                    ref.watch(firebaseAuthUserStateNotifierProvider);

                // チャンネルが存在しない場合
                if (!channel.exists) {
                  await channelSetUsecase();
                  await userSetUsecase(
                    email: firebaseAuthUser.email,
                    nickName: "ホストユーザ",
                    isHost: true,
                  );

                  // チャンネルが存在する場合
                } else {
                  // チャンネルのホストユーザのemailを取得
                  final data = channel.data() ?? {};

                  final channelState = Channel.create(
                    createAt: data["createAt"],
                    hostUserEmail: data["hostUserEmail"],
                  );

                  // ホストユーザとそれ以外のユーザで分岐
                  if (channelState.hostUserEmail == firebaseAuthUser.email) {
                    await userSetUsecase(
                      email: firebaseAuthUser.email,
                      nickName: "ホストユーザ",
                      isHost: true,
                    );
                  } else {
                    await userSetUsecase(
                      email: firebaseAuthUser.email,
                      nickName: "ゲストユーザ",
                      isHost: false,
                    );
                  }
                }

                // --------------------------------------------------
                //
                // チャンネル参加済みであることをアプリ内で状態として保持する
                //
                // --------------------------------------------------
                notifier.changeJoined(true);
              };
      }

      return ChannelJoinSubmitStateNotifier(
        channelJoinSubmitWidgetName: "チャンネル参加",
        onSubmit: onSubmit,
      );
    },
  );
}

// --------------------------------------------------
//
// StateNotifierProviderList
//
// --------------------------------------------------
class ChannelJoinSubmitStateProviderList {
  static final channelJoinSubmitStateNotifierProvider =
      channelJoinSubmitStateNotifierProviderCreator();
}
