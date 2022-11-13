import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';

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
    // ignore: unused_element
    @Default(null) @CreatedAtTimestampConverter() Timestamp? createAt,
    required String hostUserEmail,
  }) = _Channel;

  factory Channel.create({
    String? hostUserEmail,
  }) =>
      Channel._(
        hostUserEmail: hostUserEmail ?? "",
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
  ChannelStateNotifier() : super(Channel.create());

  void setChannelState(Channel channel) {
    state = channel;
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final channelStateNotifierProvider =
    StateNotifierProvider<ChannelStateNotifier, Channel>(
  (ref) => ChannelStateNotifier(),
);
