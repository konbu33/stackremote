import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../channel.dart';

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
    final channelState = ref.watch(channelStateFutureProvider);

    final channel = channelState.when(data: (data) {
      return data;
    }, error: (error, stackTrace) {
      return Channel.create();
    }, loading: () {
      return Channel.create();
    });

    return channel;
  }

  // void setChannelState(Channel channel) {
  //   state = state.copyWith(
  //     createAt: channel.createAt,
  //     hostUserEmail: channel.hostUserEmail,
  //   );
  // }
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

// --------------------------------------------------
//
//  channelStateFutureProvider
//
// --------------------------------------------------
final channelStateFutureProvider = FutureProvider<Channel>((ref) async {
  final channelGetUsecase = ref.watch(channelGetUsecaseProvider);
  final channel = await channelGetUsecase();

  return channel;
});
