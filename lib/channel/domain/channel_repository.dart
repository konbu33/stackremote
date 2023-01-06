import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/common.dart';
import '../channel.dart';

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
