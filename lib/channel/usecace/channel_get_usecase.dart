import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../rtc_video/rtc_video.dart';

final channelGetUsecaseProvider = Provider((ref) {
  final rtcChannelState = ref.watch(
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

  Future<DocumentSnapshot<Map<String, dynamic>>> execute() async {
    final channel = await FirebaseFirestore.instance
        .collection('channels')
        .doc(rtcChannelState.channelName)
        .get();

    return channel;
  }

  return execute;
});
