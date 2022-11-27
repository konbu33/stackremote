import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/channel.dart';
import '../domain/channel_repository.dart';
import '../infrastructure/channel_repository_firestore.dart';

final channelGetUsecaseProvider = Provider((ref) {
  final ChannelRepository channelRepository =
      ref.watch(channelRepositoryFirestoreProvider);

  final channelName = ref.watch(channelNameProvider);

  Future<Channel> execute() async {
    final channel = await channelRepository.get(
      channelName: channelName,
    );

    return channel;
  }

  return execute;
});
