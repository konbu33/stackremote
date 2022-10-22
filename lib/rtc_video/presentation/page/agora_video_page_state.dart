import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'agora_video_page_state.freezed.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class AgoraVideoPageState with _$AgoraVideoPageState {
  const factory AgoraVideoPageState._({
    // ignore: unused_element
    @Default(false) bool viewSwitch,
  }) = _AgoraVideoPageState;

  factory AgoraVideoPageState.create() => const AgoraVideoPageState._();
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class AgoraVideoPageStateNotifier extends StateNotifier<AgoraVideoPageState> {
  AgoraVideoPageStateNotifier() : super(AgoraVideoPageState.create()) {
    initial();
  }

  // initial
  void initial() {
    state = AgoraVideoPageState.create();
  }

  void toggleViewSwitch() {
    state = state.copyWith(viewSwitch: !state.viewSwitch);
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final agoraVideoPageStateNotifierProvider = StateNotifierProvider.autoDispose<
    AgoraVideoPageStateNotifier, AgoraVideoPageState>(
  (ref) => AgoraVideoPageStateNotifier(),
);
