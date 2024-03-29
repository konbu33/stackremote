import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';

import '../usecace/channel_get_usecase.dart';

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
    @DateTimeConverter() required DateTime? createAt,
    required String hostUserEmail,
  }) = _Channel;

  factory Channel.create({
    DateTime? createAt,
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

    logger.d("channelState: $channel");
    return channel;
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
