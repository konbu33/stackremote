import 'package:cloud_firestore/cloud_firestore.dart';

import 'channel.dart';
import 'channel_id.dart';
import 'channels.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class ChannelRepository {
  ChannelRepository({
    required this.firebaseFirestoreInstance,
  });

  final FirebaseFirestore firebaseFirestoreInstance;

  late CollectionReference<JsonMap> ref;

  Stream<Channels> fetchAll();

  Future<Channel> fetchById(String channelId);

  Future<Channel> add(Channel channel);

  Future<String> delete(String channelId);

  void update(Channel channel);
}
