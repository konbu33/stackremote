import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../user/domain/user.dart';
import '../domain/channel.dart';
import '../domain/channel_repository.dart';
import '../infrastructure/channel_repository_firestore.dart';

final channelSetUsecaseProvider = Provider.autoDispose((ref) {
  final ChannelRepository channelRepository =
      ref.watch(channelRepositoryFirestoreProvider);

  final channelName = ref.watch(channelNameProvider);

  final hostUserEmail =
      ref.watch(userStateNotifierProvider.select((value) => value.email));

  Future<void> execute() async {
    final channel = Channel.create(hostUserEmail: hostUserEmail);

    await channelRepository.set(
      channelName: channelName,
      channel: channel,
    );
  }

  return execute;
});
