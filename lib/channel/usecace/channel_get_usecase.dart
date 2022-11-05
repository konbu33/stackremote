import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../rtc_video/rtc_video.dart';
import '../domain/channel.dart';
import '../domain/channel_repository.dart';
import '../infrastructure/channel_repository_firestore.dart';

final channelGetUsecaseProvider = Provider((ref) {
  final ChannelRepository channelRepository =
      ref.watch(channelRepositoryFireBaseProvider);

  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  // Future<DocumentSnapshot<Map<String, dynamic>>> execute() async {
  Future<AsyncValue<Channel?>> execute() async {
    final asyncValue = await channelRepository.get(
      channelName: rtcChannelState.channelName,
    );

    return asyncValue;
  }

  return execute;
});
