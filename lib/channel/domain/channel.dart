import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'channel_id.dart';

part 'channel.freezed.dart';
part 'channel.g.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class Channel with _$Channel {
  const factory Channel._({
    @ChannelIdConverter() required ChannelId channelId,
    required String channelName,
  }) = _Channel;

  factory Channel.create({
    required String channelName,
  }) =>
      Channel._(
        channelId: ChannelId.create(),
        channelName: channelName,
      );

  factory Channel.reconstruct({
    ChannelId? channelId,
    String? channelName,
  }) =>
      Channel._(
        channelId: channelId ?? ChannelId.create(),
        channelName: channelName ?? "",
      );

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class ChannelStateNotifier extends StateNotifier<Channel> {
  ChannelStateNotifier({
    required String channelName,
  }) : super(Channel.create(channelName: channelName));

  void setChannel(String channelName) {
    state = state.copyWith(
      channelName: channelName,
    );
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final channelStateNotifierProvider =
    StateNotifierProvider<ChannelStateNotifier, Channel>(
  (ref) => ChannelStateNotifier(channelName: ""),
);
