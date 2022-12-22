import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../user/user.dart';

part 'video_sub_state.freezed.dart';

// --------------------------------------------------
//
//  VideoSubState
//
// --------------------------------------------------
@freezed
class VideoSubState with _$VideoSubState {
  const factory VideoSubState._({
    required int currentUidOfVideoMain,
    required AlignmentDirectional videoSubLayerAlignment,
    required bool isOnTapIgnore,
  }) = _VideoSubState;

  factory VideoSubState.create({
    required int currentUidOfVideoMain,
  }) =>
      VideoSubState._(
        currentUidOfVideoMain: currentUidOfVideoMain,
        videoSubLayerAlignment: AlignmentDirectional.topStart,
        isOnTapIgnore: false,
      );
}

// --------------------------------------------------
//
//  VideoSubStateNotifier
//
// --------------------------------------------------
class VideoSubStateNotifier extends AutoDisposeNotifier<VideoSubState> {
  @override
  VideoSubState build() {
    final currentUidOfVideoMain = ref
        .watch(userStateNotifierProvider.select((value) => value.rtcVideoUid));

    return VideoSubState.create(
      currentUidOfVideoMain: currentUidOfVideoMain,
    );
  }

  void updateCurrentUidOfVideoMain(int currentUidOfVideoMain) {
    state = state.copyWith(currentUidOfVideoMain: currentUidOfVideoMain);
  }

  void updateVideoSubLayerAlignment(
      AlignmentDirectional videoSubLayerAlignment) {
    state = state.copyWith(videoSubLayerAlignment: videoSubLayerAlignment);
  }

  void updateIsOnTapIgnore() async {
    state = state.copyWith(isOnTapIgnore: true);

    await Future.delayed(const Duration(milliseconds: 250));
    state = state.copyWith(isOnTapIgnore: false);
  }
}

// --------------------------------------------------
//
//  videoSubStateNotifierProvider
//
// --------------------------------------------------
final videoSubStateNotifierProvider =
    AutoDisposeNotifierProvider<VideoSubStateNotifier, VideoSubState>(
        () => VideoSubStateNotifier());
