import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../domain/channel.dart';
import '../domain/channel_repository.dart';

final channelRepositoryFireBaseProvider = Provider((ref) {
  return ChannelRepositoryFireBase(
    firebaseFirestoreInstance: FirebaseFirestore.instance,
  );
});

class ChannelRepositoryFireBase implements ChannelRepository {
  ChannelRepositoryFireBase({
    required this.firebaseFirestoreInstance,
  }) {
    collectionRef = firebaseFirestoreInstance.collection('channels');
  }

  @override
  final FirebaseFirestore firebaseFirestoreInstance;

  @override
  late CollectionReference<JsonMap> collectionRef;

  // --------------------------------------------------
  //
  // get
  //
  // --------------------------------------------------
  @override
  // Future<DocumentSnapshot<Map<String, dynamic>>> get({
  Future<AsyncValue<Channel?>> get({
    required String channelName,
  }) async {
    try {
      final snapshot = await collectionRef.doc(channelName).get();

      // チャンネルが存在しない場合
      if (!snapshot.exists) {
        // throw Exception();
        return const AsyncData(null);

        // チャンネルが存在する場合
      } else {
        // チャンネルのホストユーザのemailを取得
        final data = snapshot.data();

        if (data == null) {
          throw Exception();
        }

        final channel = Channel.fromJson(data);
        return AsyncData(channel);
      }

      //
    } on FirebaseException catch (e, s) {
      logger.d("$e");
      return AsyncError(e, s);
      // rethrow;
    } on Exception catch (e, s) {
      logger.d("$e");
      return AsyncError(e, s);
    }
  }

  // --------------------------------------------------
  //
  //  set
  //
  // --------------------------------------------------
  @override
  Future<void> set({
    required String channelName,
    required Channel channel,
  }) async {
    try {
      final jsonData = channel.toJson();
      await collectionRef.doc(channelName).set(jsonData);

      //
    } on FirebaseException catch (e) {
      logger.d("$e");
      rethrow;
    }
  }
}
