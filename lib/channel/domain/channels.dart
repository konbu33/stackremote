// StateNotifier
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'channel.dart';

part 'channels.freezed.dart';

// --------------------------------------------------
//
// Freezed
// First Colection
//
// --------------------------------------------------
@freezed
class Channels with _$Channels {
  const factory Channels._({
    required List<Channel> channels,
  }) = _Channels;

  factory Channels.create() => const Channels._(channels: []);

  factory Channels.reconstruct({
    required List<Channel> channels,
  }) =>
      Channels._(
        channels: channels,
      );
}

/*
// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class ChannelsController extends StateNotifier<Channels> {
  ChannelsController() : super(Channels.create()) {
    _getInitData();
  }

  void resetData(List<Channel> channels) {
    state = state.copyWith(channels: channels);
  }

  void _getInitData() {
    state = state.copyWith(
      channels: [
        Channel.create(email: "init@test.com", password: "password"),
      ],
    );
  }

  void reconstruct(List<Channel> channels) {
    state = state.copyWith(channels: channels);
  }
}
*/
