import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';

part 'channel.freezed.dart';
part 'channel.g.dart';

final channelNameProvider = StateProvider((ref) => "");

// --------------------------------------------------
//
//   Channel
//
// --------------------------------------------------
@freezed
class Channel with _$Channel {
  const factory Channel._({
    // ignore: unused_element
    @CreatedAtTimestampConverter() required Timestamp? createAt,
    required String hostUserEmail,
  }) = _Channel;

  factory Channel.create({
    Timestamp? createAt,
    String? hostUserEmail,
  }) =>
      Channel._(
        createAt: createAt,
        hostUserEmail: hostUserEmail ?? "",
      );

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
}

// --------------------------------------------------
//
//  ChannelStateNotifier
//
// --------------------------------------------------
class ChannelStateNotifier extends Notifier<Channel> {
  @override
  Channel build() {
    return Channel.create();
  }

  void setChannelState(Channel channel) {
    state = state.copyWith(
      createAt: channel.createAt,
      hostUserEmail: channel.hostUserEmail,
    );
  }
}

// --------------------------------------------------
//
//  channelStateNotifierProviderCreator
//
// --------------------------------------------------
typedef ChannelStateNotifierProvider
    = NotifierProvider<ChannelStateNotifier, Channel>;

ChannelStateNotifierProvider channelStateNotifierProviderCreator() {
  return NotifierProvider<ChannelStateNotifier, Channel>(
    () => ChannelStateNotifier(),
  );
}

// --------------------------------------------------
//
//  channelStateNotifierProvider
//
// --------------------------------------------------
final channelStateNotifierProvider = channelStateNotifierProviderCreator();
