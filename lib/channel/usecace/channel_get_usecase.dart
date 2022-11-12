import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../rtc_video/rtc_video.dart';
import '../domain/channel.dart';
import '../domain/channel_repository.dart';
import '../infrastructure/channel_repository_firestore.dart';

// final channelGetUsecaseProvider = FutureProvider((ref) {
final channelGetUsecaseProvider = Provider((ref) {
  final ChannelRepository channelRepository =
      ref.watch(channelRepositoryFirestoreProvider);

  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  Future<Channel> execute() async {
    final channel = await channelRepository.get(
      channelName: rtcChannelState.channelName,
    );

    return channel;
  }

  return execute;
});
