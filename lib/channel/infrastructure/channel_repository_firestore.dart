import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';

import '../domain/channel.dart';
import '../domain/channel_repository.dart';

final channelRepositoryFirestoreProvider = Provider<ChannelRepository>((ref) {
  final firebaseFirestoreInstance =
      ref.watch(firebaseFirestoreInstanceProvider);

  return ChannelRepositoryFirestore(
    firebaseFirestoreInstance: firebaseFirestoreInstance,
  );
});

class ChannelRepositoryFirestore implements ChannelRepository {
  ChannelRepositoryFirestore({
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
  // docDataToChannel
  //
  // --------------------------------------------------
  Channel docDataToChannel(JsonMap docData) {
    //
    String? timestampToDateTimeString(Timestamp? timestamp) {
      if (timestamp == null) return null;
      return timestamp.toDate().toString();
    }

    final createAt =
        timestampToDateTimeString(docData["createAt"] as Timestamp?);

    final jsonData = {
      ...docData,
      "createAt": createAt,
    };

    final channel = Channel.fromJson(jsonData);
    return channel;
  }

  // --------------------------------------------------
  //
  // get
  //
  // --------------------------------------------------
  @override
  Future<Channel> get({
    required String channelName,
  }) async {
    // channelNameが空文字だった場合
    if (channelName.isEmpty) return Channel.create();

    try {
      final snapshot = await ref.doc(channelName).get();

      // チャンネルが存在しない場合
      if (!snapshot.exists) {
        throw FirebaseException(
          plugin: "repository",
          code: "not_exists",
          message: "コレクションが存在しません。",
        );

        // チャンネルが存在する場合
      } else {
        final docData = snapshot.data();

        if (docData == null) {
          throw FirebaseException(
            plugin: "repository",
            code: "no_data",
            message: "ドキュメントが存在しません。",
          );
        }

        final channel = docDataToChannel(docData);

        return channel;
      }

      //
    } on FirebaseException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        message: e.message ?? "",
        code: e.code,
        stackTrace: e.stackTrace,
      );

      //
    } on Exception catch (e, s) {
      logger.d("$e, $s");
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
    try {
      final jsonData = channel.toJson();

      await ref.doc(channelName).set({
        ...jsonData,
        'createAt': FieldValue.serverTimestamp(),
      });

      //
    } on FirebaseException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        message: e.message ?? "",
        code: e.code,
        stackTrace: e.stackTrace,
      );

      //
    } on Exception catch (e, s) {
      logger.d("$e, $s");
      rethrow;
    }
  }
}
