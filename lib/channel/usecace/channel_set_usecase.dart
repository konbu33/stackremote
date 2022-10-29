import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/authentication.dart';
import 'package:stackremote/channel/domain/channel.dart';

import '../../rtc_video/rtc_video.dart';

final channelSetUsecaseProvider = Provider((ref) {
  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);

  Future<void> execute({
    Timestamp? createAt,
    String? hostUserEmail,
  }) async {
    final channel = Channel.create(hostUserEmail: firebaseAuthUser.email);

    await FirebaseFirestore.instance
        .collection('channels')
        .doc(rtcChannelState.channelName)
        // .set({...channel.toJson(), "createAt": FieldValue.serverTimestamp()});
        .set(channel.toJson());
  }

  return execute;
});
