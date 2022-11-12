import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/rtc_video/domain/rtc_channel_state.dart';

import '../../common/common.dart';
import '../domain/channel.dart';
import '../domain/channel_exception.dart';

final channelRepositoryGetProvider = FutureProvider((ref) async {
  //
  Future<Channel> channelRepositoryGet() async {
    final rtcChannelState = ref.watch(
        RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider);

    try {
      final res = await FirebaseFirestore.instance
          .collection("channels")
          .doc(rtcChannelState.channelName)
          .get();

      if (!res.exists) {
        throw const ChannelException(
          plugin: "repository",
          code: "not_exists",
          message: "コレクションが存在しません。",
        );
      }

      final data = res.data();
      if (data == null) {
        throw const ChannelException(
          plugin: "repository",
          code: "no_data",
          message: "ドキュメントが存在しません。",
        );
      }

      final channel = Channel.fromJson(data);

      return channel;

      //
    } on ChannelException catch (e) {
      logger.d("$e");
      rethrow;

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

  return await channelRepositoryGet();
});
