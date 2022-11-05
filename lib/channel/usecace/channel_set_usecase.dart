import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/authentication.dart';
import '../../rtc_video/rtc_video.dart';
import '../channel.dart';
import '../domain/channel_repository.dart';
import '../infrastructure/channel_repository_firestore.dart';

final channelSetUsecaseProvider = Provider((ref) {
  final ChannelRepository channelRepository =
      ref.watch(channelRepositoryFireBaseProvider);

  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);

  Future<void> execute({
    Timestamp? createAt,
    String? hostUserEmail,
  }) async {
    final channel = Channel.create(hostUserEmail: firebaseAuthUser.email);

    await channelRepository.set(
      channelName: rtcChannelState.channelName,
      channel: channel,
    );
  }

  return execute;
});
