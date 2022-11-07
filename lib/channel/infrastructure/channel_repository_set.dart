import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/rtc_video/domain/rtc_channel_state.dart';

import '../../common/common.dart';
import '../domain/channel.dart';

final channelRepositorySetProvider = FutureProvider((ref) async {
  //
  Future<void> channelRepositorySet() async {
    final rtcChannelState = ref.watch(
        RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

    final channelState = ref.watch(channelStateNotifierProvider);

    try {
      final jsonData = channelState.toJson();
      await FirebaseFirestore.instance
          .collection("channels")
          .doc(rtcChannelState.channelName)
          .set(jsonData);

      //
    } on FirebaseException catch (e) {
      logger.d("$e");
      rethrow;

      //
    } on Exception catch (e) {
      logger.d("$e");
      rethrow;
    }
  }

  return await channelRepositorySet();
});

//   // --------------------------------------------------
//   //
//   //  set
//   //
//   // --------------------------------------------------
//   @override
//   Future<void> set({
//     required String channelName,
//     required Channel channel,
//   }) async {
//     try {
//       final jsonData = channel.toJson();
//       await collectionRef.doc(channelName).set(jsonData);

//       //
//     } on FirebaseException catch (e) {
//       logger.d("$e");
//       rethrow;

//       //
//     } on Exception catch (e, s) {
//       logger.d("$e");
//       rethrow;
//     }
//   }
// }
