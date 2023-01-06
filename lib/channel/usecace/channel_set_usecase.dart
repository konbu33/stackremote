import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/authentication.dart';

import '../channel.dart';

final channelSetUsecaseProvider = Provider((ref) {
  final ChannelRepository channelRepository =
      ref.watch(channelRepositoryFirestoreProvider);

  final channelName = ref.watch(channelNameProvider);

  final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);

  Future<void> execute() async {
    final channel = Channel.create(hostUserEmail: firebaseAuthUser.email);

    await channelRepository.set(
      channelName: channelName,
      channel: channel,
    );
  }

  return execute;
});
