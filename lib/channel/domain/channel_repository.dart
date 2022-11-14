import 'package:cloud_firestore/cloud_firestore.dart';

import 'channel.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class ChannelRepository {
  ChannelRepository({
    required this.firebaseFirestoreInstance,
  });

  late CollectionReference<JsonMap> ref;

  final FirebaseFirestore firebaseFirestoreInstance;

  Future<Channel> get({
    required String channelName,
  });

  Future<void> set({
    required String channelName,
    required Channel channel,
  });
}
