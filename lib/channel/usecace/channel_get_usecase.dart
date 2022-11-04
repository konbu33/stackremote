import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../rtc_video/rtc_video.dart';
import '../domain/channel_repository.dart';
import '../infrastructure/channel_repository_firestore.dart';

final channelGetUsecaseProvider = Provider((ref) {
  final ChannelRepository channelRepository =
      ref.read(channelRepositoryFireBaseProvider);

  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  Future<DocumentSnapshot<Map<String, dynamic>>> execute() async {
    final channel = await channelRepository.get(
      channelName: rtcChannelState.channelName,
    );

    return channel;
  }

  return execute;
});
