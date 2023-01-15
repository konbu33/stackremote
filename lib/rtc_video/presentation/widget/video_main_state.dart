import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../user/user.dart';

part 'video_main_state.freezed.dart';

// --------------------------------------------------
//
//  VideoMainState
//
// --------------------------------------------------
@freezed
class VideoMainState with _$VideoMainState {
  const factory VideoMainState._({
    required int currentUid,
    required bool isMuteVideo,
    required String nickName,
  }) = _VideoMainState;

  factory VideoMainState.create({
    required int currentUid,
    required bool isMuteVideo,
    required String nickName,
  }) =>
      VideoMainState._(
        currentUid: currentUid,
        isMuteVideo: isMuteVideo,
        nickName: nickName,
      );
}

// --------------------------------------------------
//
//  VideoMainStateNotifier
//
// --------------------------------------------------
class VideoMainStateNotifier extends AutoDisposeNotifier<VideoMainState> {
  @override
  VideoMainState build() {
    final currentUid = ref
        .watch(userStateNotifierProvider.select((value) => value.rtcVideoUid));

    final isMuteVideo = ref
        .watch(userStateNotifierProvider.select((value) => value.isMuteVideo));

    final nickName =
        ref.watch(userStateNotifierProvider.select((value) => value.nickName));

    return VideoMainState.create(
      currentUid: currentUid,
      isMuteVideo: isMuteVideo,
      nickName: nickName,
    );
  }

  void updateCurrentUid(int currentUid) {
    state = state.copyWith(currentUid: currentUid);
  }

  void updateIsMuteVideo(bool isMuteVideo) {
    state = state.copyWith(isMuteVideo: isMuteVideo);
  }

  void updateNickName(String nickName) {
    state = state.copyWith(nickName: nickName);
  }
}

// --------------------------------------------------
//
//  videoMainStateNotifierProvider
//
// --------------------------------------------------
final videoMainStateNotifierProvider =
    AutoDisposeNotifierProvider<VideoMainStateNotifier, VideoMainState>(
        () => VideoMainStateNotifier());
