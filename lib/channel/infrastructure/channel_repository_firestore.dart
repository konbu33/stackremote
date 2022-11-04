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
    ref = firebaseFirestoreInstance.collection('channels');
  }

  @override
  final FirebaseFirestore firebaseFirestoreInstance;

  @override
  late CollectionReference<JsonMap> ref;

  // --------------------------------------------------
  //
  // get
  //
  // --------------------------------------------------
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get({
    required String channelName,
  }) async {
    // Firestore Data Stream Listen
    try {
      final channel = await firebaseFirestoreInstance
          .collection('channels')
          .doc(channelName)
          .get();

      return channel;

      //
    } on FirebaseException catch (e) {
      logger.d("$e");
      rethrow;
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
    // Firestore Data Stream Listen
    try {
      await firebaseFirestoreInstance
          .collection('channels')
          .doc(channelName)
          .set(channel.toJson());

      //
    } on FirebaseException catch (e) {
      logger.d("$e");
      rethrow;
    }
  }
}
