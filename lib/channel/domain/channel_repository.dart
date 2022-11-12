import 'package:cloud_firestore/cloud_firestore.dart';

import 'channel.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class ChannelRepository {
  ChannelRepository({
    required this.firebaseFirestoreInstance,
  });

  final FirebaseFirestore firebaseFirestoreInstance;

  late CollectionReference<JsonMap> collectionRef;

  Future<Channel> get({
    required String channelName,
  });

  Future<void> set({
    required String channelName,
    required Channel channel,
  });
}
