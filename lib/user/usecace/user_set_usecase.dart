import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../rtc_video/rtc_video.dart';

import '../domain/user.dart';
import '../domain/user_repository.dart';
import '../infrastructure/user_repository_firestore.dart';

final userSetUsecaseProvider = Provider((ref) {
  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  final userState = ref.watch(userStateNotifierProvider);

  Future<void> execute() async {
    await userRepository.set(
      channelName: rtcChannelState.channelName,
      email: userState.email,
      user: userState,
    );
  }

  return execute;
});
