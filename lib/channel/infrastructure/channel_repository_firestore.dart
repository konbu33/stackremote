import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../domain/channel.dart';
import '../domain/channel_repository.dart';
import '../domain/channel_exception.dart';

final firebaseFirestoreInstanceProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

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
  // get
  //
  // --------------------------------------------------
  @override
  Future<Channel> get({
    required String channelName,
  }) async {
    try {
      final snapshot = await ref.doc(channelName).get();

      // チャンネルが存在しない場合
      if (!snapshot.exists) {
        // throw Exception();
        throw const ChannelException(
          plugin: "repository",
          code: "not_exists",
          message: "コレクションが存在しません。",
        );

        // チャンネルが存在する場合
      } else {
        // チャンネルのホストユーザのemailを取得
        final data = snapshot.data();

        if (data == null) {
          throw const ChannelException(
            plugin: "repository",
            code: "no_data",
            message: "ドキュメントが存在しません。",
          );
        }

        final channel = Channel.fromJson(data);
        return channel;
      }

      //
    } on FirebaseException catch (e, s) {
      logger.d("$e, $s");
      rethrow;

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
      await ref.doc(channelName).set(jsonData);

      //
    } on FirebaseException catch (e) {
      logger.d("$e");
      rethrow;

      //
    } on Exception catch (e, s) {
      logger.d("$e, $s");
      rethrow;
    }
  }
}
