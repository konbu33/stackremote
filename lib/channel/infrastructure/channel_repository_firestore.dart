import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/channel.dart';
import '../domain/channel_repository.dart';
import '../domain/channel_id.dart';
import '../domain/channels.dart';

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
  //   fetchAll
  //
  // --------------------------------------------------
  @override
  Stream<Channels> fetchAll() {
    // Firestore Data Stream Listen
    try {
      final Stream<QuerySnapshot<JsonMap>> snapshotStream = ref.snapshots();

      // Stream Data Transfar from Firestore Stream to Object Stream
      Stream<Channels> transferStream(
          Stream<QuerySnapshot<JsonMap>> snapshotStream) async* {
        // Out snapshot from Stream
        await for (final snapshot in snapshotStream) {
          // from Firestore Snapshot to Channel Type Object Collection.
          final docDatas = snapshot.docs.map(((doc) {
            final docData = doc.data();
            return Channel.fromJson(docData);
          })).toList();

          final Channels channels = Channels.reconstruct(channels: docDatas);
          yield channels;
        }
      }

      return transferStream(snapshotStream);
    } catch (e) {
      rethrow;
    }
  }

  // --------------------------------------------------
  //
  //   fetchById
  //
  // --------------------------------------------------

  @override
  Future<Channel> fetchById(String channelId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await ref.doc(channelId).get();
      final docData = doc.data();
      if (docData == null) {
        throw FirebaseException(
            plugin: "channelRepository",
            code: "fetchById",
            message: "ユーザが存在しません");
      }
      final channel = Channel.fromJson(docData);
      return channel;
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  // --------------------------------------------------
  //
  //   add
  //
  // --------------------------------------------------
  @override
  Future<Channel> add(Channel channel) async {
    final channelJson = channel.toJson();
    // final String docId = channel.channelId.value.toString();
    // await ref.doc(docId).set(channelJson);
    return channel;
  }

  // --------------------------------------------------
  //
  //   delete
  //
  // --------------------------------------------------
  @override
  Future<String> delete(String channelId) async {
    await ref.doc(channelId).delete();
    return "Delete Complete.";
  }

  // --------------------------------------------------
  //
  //   update
  //
  // --------------------------------------------------
  @override
  void update(Channel channel) async {
    final channelJson = channel.toJson();
    // final String docId = channel.channelId.value.toString();
    // await ref.doc(docId).set(channelJson);
  }
}
