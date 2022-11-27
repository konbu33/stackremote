import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../user/user.dart';
import '../domain/rtc_channel_state.dart';
import '../infrastructure/rtc_video_repository.dart';
import '../infrastructure/rtc_video_repository_agora.dart';

final channelLeaveUsecaseProvider = Provider((ref) async {
  final RtcVideoRepository rtcVideoRepository =
      await ref.watch(rtcVideoRepositoryAgoraProvider);

  Future<void> execute() async {
    // --------------------------------------------------
    //
    // チャンネル離脱
    //
    // --------------------------------------------------
    await rtcVideoRepository.channelLeave();

    // --------------------------------------------------
    //
    // DBにチャンネル情報とユーザ情報を登録
    //
    // --------------------------------------------------
    final userUpdateUsecase = ref.read(userUpdateUsecaseProvider);
    await userUpdateUsecase<FieldValue>(
      comment: "",
      leavedAt: FieldValue.serverTimestamp(),
      isOnLongPressing: false,
      pointerPosition: const Offset(0, 0),
      displayPointerPosition: const Offset(0, 0),
    );

    // --------------------------------------------------
    //
    // チャンネル離脱済みであることをアプリ内で状態として保持する
    //
    // --------------------------------------------------
    // final rtcChannelStateNotifier =
    //     ref.watch(rtcChannelStateNotifierProvider.notifier);
    // rtcChannelStateNotifier.changeJoined(false);

    ref
        .watch(RtcChannelState.isJoinedProvider.notifier)
        .update((state) => false);
  }

  return execute;
});
