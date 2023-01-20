import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'video_sub_state.freezed.dart';

// --------------------------------------------------
//
//  VideoSubState
//
// --------------------------------------------------
@freezed
class VideoSubState with _$VideoSubState {
  const factory VideoSubState._({
    required AlignmentDirectional videoSubLayerAlignment,
    required bool isOnTapIgnore,
  }) = _VideoSubState;

  factory VideoSubState.create() => const VideoSubState._(
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
    return VideoSubState.create();
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
